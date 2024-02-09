import Foundation
import Combine
import FirebaseAuth
import FirebaseDatabase
import Firebase

enum SessionStateEnum {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionStateEnum {get}
    var userDetails: SessionUserDetails? {get}
    func logout()
}

final class SessionServiceViewModelController: ObservableObject, SessionService {
    // marked these two as published because we are going to use these later to listen to changes
    // and if there are changes, then redraw our view.
    @Published var state: SessionStateEnum = .loggedOut
    @Published var userDetails: SessionUserDetails?

    
    private var handler: AuthStateDidChangeListenerHandle?
    // initializion below ensures that the user refresh method reads the values from the database for the currently logged in user. Used in the info view.
    init() {
        setupFirebaseAuthHandler()
    }
    // signs the user out of the application using Firebase's package
    func logout() {
        try? Auth.auth().signOut()

    }
    
    func setupFirebaseAuthHandler() {
        handler = Auth
            .auth()
            .addStateDidChangeListener { [weak self] _, user in
                guard let self = self else { return }
                self.state = user == nil ? .loggedOut : .loggedIn
                
                if let uid = user?.uid {
                    self.handleUserRefresh(with: uid)
                }
            }
    }
}




extension SessionServiceViewModelController {
    // method invoked on the InfoView to update all child values associated with the user, given the dictionary of data. Custom RegistrationKeys are utilized to assign key:value pairs for the dictionary to be read in by Firebase. Use of safe unwrapping techniques for error handling.
    func updateUserInfo(firstName: String, lastName: String, username: String, profileImageUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = Database.database().reference().child("users").child(uid)
        
        let updatedInfo: [String: Any] = [
            UserRegistrationKeys.firstName.rawValue: firstName,
            UserRegistrationKeys.lastName.rawValue: lastName,
            UserRegistrationKeys.username.rawValue: username,
            UserRegistrationKeys.profileImageUrl.rawValue: profileImageUrl,
        ]
        
        userRef.updateChildValues(updatedInfo) { error, _ in
            if let error = error {
                print("Failed to update user info: \(error)")
            } else {
                print("User info updated successfully")
            }
        }
    }

}
// Initialized when the user logs into the app, the purpose of these methods are to are to ensure that once after the user is logged in through the Firebase Auth functions, their details are obtained safely, through the use of a handler to check if any objects are returned as nil, as this would mean the last action was a logout. Otherwise, a !nil object proves says that the user is currently logged in. As such, modifications to the state take place through a ternary operator.
extension SessionServiceViewModelController {
    

    // method for retrieving the most up to date user details from the firebase realtime database once verification of the user being logged-in is confirmed. dispatch information to the main thread so that updates to the UI may take place.
    func handleUserRefresh(with uid: String) {
        Database
            .database()
            .reference()
            .child("users")
            .child(uid)
            .observeSingleEvent(of: .value) { [weak self] snapshot, _ in // Add _, _ for the second argument
                if let value = snapshot.value as? [String: Any],
                   let email = value[UserRegistrationKeys.email.rawValue] as? String,
                   let firstName = value[UserRegistrationKeys.firstName.rawValue] as? String,
                   let lastName = value[UserRegistrationKeys.lastName.rawValue] as? String,
                   let username = value[UserRegistrationKeys.username.rawValue] as? String,
                   let profileImageUrl = value[UserRegistrationKeys.profileImageUrl.rawValue] as? String {
                    
                    // Fetch optional properties
                    let friendCount = value["friendCount"] as? Int
                    let bio = value["bio"] as? String
                    let isFollowing = value["isFollowing"] as? Bool
                    
                    var following: [String]? = nil
                    if let followingArray = value["following"] as? [String] {
                        following = followingArray
                    }
                    
                    DispatchQueue.main.async {
                        self?.userDetails = SessionUserDetails(uid: uid, email: email, firstName: firstName, lastName: lastName,
                                                               username: username, profileImageUrl: profileImageUrl,
                                                               friendCount: friendCount, bio: bio, isFollowing: isFollowing, following: following ?? [])
                    }
                } else {
                    print("Error fetching data or data format incorrect")
                }
            }
    }
}
