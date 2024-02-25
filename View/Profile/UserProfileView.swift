//
//  UserProfileView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/21/24.
//
//  TODOs:
//  - Implement Dream Box view functionality
//  - Upload custom banner
//  - Edit name, username, and profile picture
//      - Edit Profile Button
//  - Add bio functionality
//  - Fix scrolling view bug
//  - Add color indicator line on segmented control view

import SwiftUI
import FirebaseAuth

struct UserProfileView: View {
    @StateObject private var viewModel = SessionServiceViewModelController()
    @StateObject private var statsViewModel = StatsViewModel() // Add StatsViewModel
    @StateObject private var feedViewModel = FeedViewModel() // Add StatsViewModel
    @StateObject private var completedGoalsViewModel = UpcomingGoalsViewModel() // Add StatsViewModel
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var isDreamBoxPresented = false // State to control the sheet presentation
    @State private var selectedSegmentIndex = 0
    @State private var user: User?
    @State private var showingPhotoPicker = false
    @State private var showingAddStatSheet = false
    @State private var showingEditStatSheet = false
    @State private var showingMenu = false
    @State private var statToEdit: Stat?
    @State private var navigateToAboutApp = false // State to control navigation to About the App view
    @State private var navigateToFullView: Bool = false // State to control navigation to the new full view

    var body: some View {
        NavigationView {
            Group {
                if viewModel.state == .loggedIn, let userDetails = viewModel.userDetails {
                    userProfileContent(userDetails: userDetails)
                } else {
                    Text("Loading profile...").foregroundColor(.gray).font(.headline)
                }
            }
            .onAppear {
                viewModel.setupFirebaseAuthHandler()
            }
            .navigationBarTitle("Profile", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                self.showingMenu = true
            }) {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .foregroundColor(.primary)
            })
            .actionSheet(isPresented: $showingMenu) {
                ActionSheet(title: Text("Menu"), buttons: [
                    .default(Text("About the App")) {
                        self.navigateToAboutApp = true
                    },
                    .default(Text("Sign Out")) {
                        viewModel.logout() // Sign out logic
                    },
                    .cancel()
                ])
            }
            .background(
                NavigationLink(destination: LegalDocumentsView(), isActive: $navigateToAboutApp) {
                    EmptyView()
                }
            )
        }
        .accentColor(.blue) // This sets the accent color for the navigation view which adapts to dark mode
    }
    
    private func userProfileContent(userDetails: SessionUserDetails) -> some View {
        ScrollView {
            VStack {
                bannerImage
                profileImage
                userInfo(userDetails: userDetails)
                FriendCountView(friendCount: profileViewModel.friendCount)
                    .padding(.horizontal)
                Spacer() // Add a spacer before the SegmentedControlView
                SegmentedControlView(selection: $selectedSegmentIndex)
                    .frame(maxWidth: .infinity) // Ensure it takes the full width available
                
                Spacer() // Add a spacer after the SegmentedControlView
                
                // Conditional content based on the selected segment
                Group {
                    if selectedSegmentIndex == 0 {
                        UserFeedView(viewModel: feedViewModel)
                    } else if selectedSegmentIndex == 1 {
                        statsSection
                    }
//                    } else if selectedSegmentIndex == 2 {
//                        AchievementView()
//                    }
                    else {
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.top)
        }
        .onAppear {
            if let currentUserUID = Auth.auth().currentUser?.uid {
                profileViewModel.observeFriendCount(for: currentUserUID)
            }
        }
    }
    struct SegmentedControlView: View {
        @Binding var selection: Int
        let categories = ["Activity", "Stats"]//, "Completed"]
        
        var body: some View {
            HStack(spacing: 10) { // Decrease spacing if necessary
                ForEach(categories.indices, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            selection = index
                        }
                    }) {
                        Text(categories[index])
                            .fontWeight(.semibold)
                            .foregroundColor(selection == index ? .black : .gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20) // Increase horizontal padding
                            .lineLimit(1) // Ensure text does not wrap
                            .minimumScaleFactor(0.5) // Allow text to scale down if needed
                    }
                    .fixedSize(horizontal: false, vertical: true) // Allow button to grow horizontally as needed
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal) // Ensure there's some padding from the screen edges
        }
    }
    
    //    struct ActivityView: View {
    //        var body: some View {
    //            VStack(spacing: 16) {
    //                Text("Activity Content")
    //                    .font(.title2)
    //                    .fontWeight(.bold)
    //                    .frame(maxWidth: .infinity, alignment: .leading)
    //                // Your activity content here...
    //            }
    //            .padding()
    //            .background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color.white))
    //            .shadow(radius: 5)
    //        }
    //    }
    
    struct AchievementView: View {
        var body: some View {
            VStack(spacing: 16) {
                Text("Achievement Content")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                // Your achievement content here...
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 25.0, style: .continuous).fill(Color.white))
            .shadow(radius: 5)
        }
    }
    
    var statsSection: some View {
        StatsView(viewModel: statsViewModel) // Incorporate StatsView
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var bannerImage: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .frame(width: geometry.size.width)
                    .edgesIgnoringSafeArea(.all) // Makes the banner extend to the edges of the screen, including the top safe area.
            }
        }
        .frame(height: 180) // Specify the height of the banner.
    }
    
    var profileImage: some View {
        Group {
            if let imageUrl = URL(string: viewModel.userDetails?.profileImageUrl ?? ""),
               let imageData = try? Data(contentsOf: imageUrl),
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
            } else {
                Image("default_profile") // Default or placeholder image
                    .resizable()
            }

        }
        .scaledToFill()
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white, lineWidth: 4))
        .shadow(radius: 10)
        .offset(y: -50)
        .padding(.bottom, -50)
    }
    
    func userInfo(userDetails: SessionUserDetails) -> some View {
        
        return VStack(alignment: .center, spacing: 10) {
            HStack {
                Text("\(userDetails.firstName) \(userDetails.lastName)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            
            //                Button(action: {
            //                    isDreamBoxPresented = true
            //                }) {
            //                    Image(systemName: "cloud.fill") // System cloud icon
            //                        .resizable()
            //                        .scaledToFit()
            //                        .frame(width: 24, height: 24) // Adjust the size as needed
            //                        .foregroundColor(.blue) // Set the icon color to blue
            //                }
            //                .sheet(isPresented: $isDreamBoxPresented) {
            //                    DreamBoxView() // Present DreamBoxView when the cloud icon is tapped
            //                }
            
            // Display the user's username
            if !userDetails.username.isEmpty {
                Text("@\(userDetails.username)")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            
//            HStack(spacing: 20) {
//                NavigationLink(destination: EditProfileView()) {
//                    HStack {
//                        Image(systemName: "pencil") // Use a pencil icon for editing
//                        Text("Edit Profile")
//                    }
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(height: 44)
//                    .background(Color.blue)
//                    .cornerRadius(8)
//                }
//            }
//            .padding(.top)
        }
        .foregroundColor(.primary) // Use primary color which adapts automatically to light/dark mode

    }
    
    func bioSection(bio: String?) -> some View {
        Group {
            if let bio = bio {
                Text(bio)
                    .font(.body)
                    .padding()
            }
        }
    }
    
    var friendsStats: some View {
        HStack {
            Image(systemName: "person.3").foregroundColor(.primary) // Ensure the icon color adapts to dark mode
            Text("\(user?.friends ?? 0) Tribe Members")
                .font(.subheadline)
                .foregroundColor(.primary) // Use primary color for text
        }
    }
}

