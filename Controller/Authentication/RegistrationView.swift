import SwiftUI
import Firebase
import Combine

struct RegistrationView: View {
    @State private var profileImage: UIImage? = UIImage(named: "plus_photo") // Default image
    @State private var email = ""
    @State private var password = ""
    @State private var firstname = ""
    @State private var lastname = ""
    @State private var username = ""
    @State private var isImagePickerPresented = false
    @State private var isMainTabPresented = false
    @State private var isLoginPresented = false
    @State private var subscriptions = Set<AnyCancellable>()
    @State private var errorMessage: String = ""


    @Environment(\.presentationMode) var presentationMode
    private let registrationService: RegistrationService
    
    // Initializer for dependency injection
    init(registrationService: RegistrationService = RegistrationServiceController()) {
        self.registrationService = registrationService
    }
    
    var body: some View {
        VStack {
            Button(action: { self.isImagePickerPresented = true }) {
                Image(uiImage: profileImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 128, height: 128)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
            }
            .padding(.top)
            
            VStack(spacing: 10) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("First Name", text: $firstname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Last Name", text: $lastname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Display error message if present
                 if !errorMessage.isEmpty {
                     Text(errorMessage)
                         .foregroundColor(.red)
                         .padding()
                 }
                 
                 Button("Sign Up") {
                     handleRegistration()
                 }
                 .frame(height: 50)
                 .frame(maxWidth: .infinity)
                 .background(Color.blue)
                 .foregroundColor(.white)
                 .cornerRadius(5)
             }
             .padding()
            
            Spacer()
            
            Button("Already have an account? Log In") {
                self.isLoginPresented = true
            }
            .sheet(isPresented: $isLoginPresented) {
                 LoginView() // Assume you have a LoginView for SwiftUI
            }
        }
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $profileImage)
        }
        .fullScreenCover(isPresented: $isMainTabPresented) {
             MainTabView() // Assume you have a MainTabView for SwiftUI
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func handleRegistration() {
        print("handleRegistration - Started")
        let registrationInfo = UserRegistrationInfo(email: email, password: password, firstName: firstname, lastName: lastname, username: username)
        
        guard let image = profileImage, image != UIImage(named: "plus_photo") else {
            print("handleRegistration - No Profile Image to Upload")
            registerUser(with: registrationInfo)
            return
        }

        print("handleRegistration - Profile Image Found, Starting Upload")
        registerUser(with: registrationInfo, profileImage: image)
    }

    func registerUser(with registrationInfo: UserRegistrationInfo, profileImage: UIImage? = nil) {
        registrationService.register(with: registrationInfo, profileImage: profileImage ?? UIImage())
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("RegistrationView - Registration Finished")
                    self.proceedToMainTab()
                case .failure(let error):
                    print("RegistrationView - Registration Error: \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }, receiveValue: { _ in
                print("RegistrationView - Received Value")
            })
            .store(in: &subscriptions) // Make sure to store the cancellable
    }


    func proceedToMainTab() {
        DispatchQueue.main.async {
            self.presentationMode.wrappedValue.dismiss() // Dismiss the current view
            self.isMainTabPresented = true // Present the main tab view
        }
    }
    

    func updateProfileImage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            print("updateProfileImage - Failed to get JPEG representation of UIImage")
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            print("updateProfileImage - No User ID found")
            return
        }

        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)

        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("updateProfileImage - Error during image upload: \(error.localizedDescription)")
                completion(nil)
                return
            }

            ref.downloadURL { (url, error) in
                if let error = error {
                    print("updateProfileImage - Error getting download URL: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let profileImageUrl = url?.absoluteString else {
                    print("updateProfileImage - No URL from downloadURL")
                    completion(nil)
                    return
                }

                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    if let err = err {
                        print("updateProfileImage - Error updating user record: \(err.localizedDescription)")
                        completion(nil)
                    } else {
                        print("updateProfileImage - User record updated with new image URL")
                        completion(url)
                    }
                }
            }
        }
    }
    
    struct ImagePicker: UIViewControllerRepresentable {
        @Binding var image: UIImage?
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.allowsEditing = true
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
            var parent: ImagePicker
            
            init(_ parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                if let uiImage = info[.editedImage] as? UIImage {
                    parent.image = uiImage
                }
                picker.dismiss(animated: true)
            }
        }
    }
    
}
