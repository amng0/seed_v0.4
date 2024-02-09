//
//  UserService.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/28/23.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()

    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
          REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
              // DEBUG: Print raw JSON data
              print("Raw JSON data: \(snapshot.value)")

              guard let dictionary = snapshot.value as? [String: AnyObject],
                    let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
                  // DEBUG: Error in forming dictionary or data object
                  print("Error in forming dictionary or data object")
                  return
              }
              
              // DEBUG: Print the dictionary and data
              print("Dictionary: \(dictionary)")
              print("Data for JSON decoding: \(data)")
              
              do {
                  // Decode the JSON data into a User object
                  let user = try JSONDecoder().decode(User.self, from: data)
                  // DEBUG: Print decoded User
                  print("Decoded User: \(user)")
                  completion(user)
              } catch {
                  // DEBUG: Print error in decoding
                  print("Error decoding User: \(error.localizedDescription)")
              }
        }
    }
    
    func fetchUsers(completion: @escaping ([User]) -> Void) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject],
                  let data = try? JSONSerialization.data(withJSONObject: dictionary) else { return }
            
            do {
                // Decode the JSON data into a User object
                let user = try JSONDecoder().decode(User.self, from: data)
                users.append(user)
                completion(users)
            } catch {
                print("Error decoding User: \(error)")
            }
        }
    }
}

    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(Int) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                
                //let stats = UserRelationStats(friends: friends)
                //completion(stats)
            }
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping(URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let filename = NSUUID().uuidString
        let ref = STORAGE_PROFILE_IMAGES.child(filename)
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { (url, error) in
                guard let profileImageUrl = url?.absoluteString else { return }
                let values = ["profileImageUrl": profileImageUrl]
                
                REF_USERS.child(uid).updateChildValues(values) { (err, ref) in
                    completion(url)
                }
            }
        }
    }
    
    func saveUserData(user: User, completion: @escaping(DatabaseCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["firstname": user.firstName,
                      "lastname": user.lastName,
                      "username": user.username,
                      "bio": user.bio ?? ""]
        
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
    }
    
//    func fetchUser(withUsername username: String, completion: @escaping(User) -> Void) {
//        REF_USER_USERNAMES.child(username).observeSingleEvent(of: .value) { snapshot in
//            guard let uid = snapshot.value as? String else { return }
//            self.fetchUser(uid: uid, completion: completion)
//        }


