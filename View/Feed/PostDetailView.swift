import SwiftUI

struct PostDetailView: View {
    @ObservedObject var viewModel: FeedViewModel
    var post: FeedPost
    var profileImageUrl: String  // Changed to String
    var userDetails: SessionUserDetails
    @State private var newCommentText: String = ""
    //@State private var keyboardHeight: CGFloat = 0
    private let globalPadding: CGFloat = 16
    @FocusState private var isCommentFieldFocused: Bool // Step 1: Add FocusState property
    
    var body: some View {
        VStack(spacing: 0){
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    UserInfoView(firstName: userDetails.firstName, lastName: userDetails.lastName, username: userDetails.username, profileImageUrl: post.userDetails.profileImageUrl, timestamp: post.timestamp)
                        .padding(.horizontal, globalPadding)
                    
                    if let caption = post.caption {
                        Text(caption)
                            .font(.body)
                        //.padding(.vertical, 4)
                            .padding(.horizontal, globalPadding)
                    }
                    
                    HStack(spacing: globalPadding) {
                        Button(action: {
                            let postIdString = post.id.uuidString
                            if post.isLikedByCurrentUser {
                                viewModel.unlikePost(postId: postIdString)
                            } else {
                                viewModel.likePost(postId: postIdString)
                            }
                        }) {
                            Image(systemName: post.isLikedByCurrentUser ? "heart.fill" : "heart")
                                .foregroundColor(post.isLikedByCurrentUser ? .red : .gray) // Red when liked
                        }
                        .foregroundColor(post.isLikedByCurrentUser ? .red : .gray) // Red when liked
                        Text("\(post.likes)")
                        // Adjust this button to focus on the comment text field
                        Button(action: {
                            self.isCommentFieldFocused = true // Step 2: Trigger focus on the text field
                        }) {
                            HStack {
                                Image(systemName: "message")
                                    .foregroundColor(.gray)
                                Text("\(post.comments?.count ?? 0)")
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                    }
                    //.padding(.vertical, 2)
                    .padding(.horizontal, globalPadding)
                    
                    Divider()
                        .padding(.horizontal, globalPadding)
                    
                    
                    if let comments = post.comments {
                        ForEach(comments, id: \.id) { comment in
                            CommentView(comment: comment, viewModel: viewModel)
                        }
                    } else {
                        Text("No comments yet")
                            .foregroundColor(.secondary)
                            .padding(.horizontal, globalPadding)
                    }
                }
                .padding(.top, globalPadding)
            }
            // Comment input area
            HStack {
                TextField("Write a comment...", text: $newCommentText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isCommentFieldFocused) // Use the focus state here
                
                
                Button(action: postComment) {
                    Text("Send")
                }
                .disabled(newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, globalPadding)
        }
            //.padding(.bottom, keyboardHeight + globalPadding) // Add padding at the bottom equal to the keyboard's height
            //.animation(.easeOut(duration: 0.16)) // Smooth transition when keyboard appears/disappears
            //.onAppear {
                // Set up notifications for when the keyboard shows/hides
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (notification) in
//                    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                        keyboardHeight = keyboardSize.height
//                    }
//                }
                
//                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (notification) in
//                    keyboardHeight = 0

        //}
        .navigationBarTitle("Post Details", displayMode: .inline)
        // .padding(.bottom, keyboardHeight) // This will move the VStack up when the keyboard appears
         .animation(.easeOut(duration: 0.16))
         .onDisappear{
             // Post a notification when navigating back to the feed view
                        NotificationCenter.default.post(name: NSNotification.Name("RefreshFeedNotification"), object: nil)
         }
    }

    
    private func postComment() {
        guard !newCommentText.isEmpty, let authorId = viewModel.currentUserId else { return }
        
        let newComment = Comment(id: UUID().uuidString, text: newCommentText, authorId: authorId, timestamp: Date())
        
        viewModel.addComment(to: post.id.uuidString, comment: newComment)
        
        newCommentText = ""
    }


    struct KeyboardResponder {
        @State private var keyboardHeight: CGFloat = 0

        var body: some View {
            GeometryReader { geometry in
                // We're just creating an invisible view that will resize
                // and trigger our padding changes.
                Color.clear
                    .onAppear {
                        NotificationCenter.default.addObserver(
                            forName: UIResponder.keyboardWillShowNotification,
                            object: nil, queue: .main) { notification in
                                let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                                let keyboardRect = geometry.frame(in: .global).intersection(keyboardFrame)
                                self.keyboardHeight = keyboardRect.height
                            }

                        NotificationCenter.default.addObserver(
                            forName: UIResponder.keyboardWillHideNotification,
                            object: nil, queue: .main) { _ in
                                self.keyboardHeight = 0
                            }
                    }
            }
        }
    }
}

struct CommentView: View {
    var comment: Comment
    @ObservedObject var viewModel: FeedViewModel  // Assuming this has the necessary fetchUserDetails method
    @State private var authorDetails: SessionUserDetails?
    @State private var isImageLoaded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if isImageLoaded, let authorDetails = authorDetails {
                HStack {
                    if let imageUrl = authorDetails.profileImageUrl, let url = URL(string: imageUrl) {
                        ProfileImageView(imageUrl: url)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .padding(10)
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(Color.gray))
                            .foregroundColor(.white)
                    }
                    VStack(alignment: .leading) {
                        Text("\(authorDetails.firstName) \(authorDetails.lastName)")
                            .font(.headline)
                        Text(comment.text)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                Text(comment.timestamp.formatted())
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding(.leading, 44)
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
        .padding(.horizontal)
        .onAppear {
            fetchAuthorDetails()
        }
    }

    func fetchAuthorDetails() {
        viewModel.fetchUserDetails(userId: comment.authorId) { userDetails in
            self.authorDetails = userDetails
            self.isImageLoaded = userDetails?.profileImageUrl != nil
        }
    }
}


struct ProfileImageView: View {
    let imageUrl: URL
    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
                case .success(let image):
                    image.resizable()
                         .aspectRatio(contentMode: .fill)
                case .empty, .failure:
                    EmptyView() // Optionally show a placeholder or nothing
                @unknown default:
                    EmptyView()
            }
        }
    }
}


