//
//  AuthService.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/28/23.
//

import UIKit
import Firebase
import FirebaseAuth

struct AuthCredentials{
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService{
    static let shared = AuthService()
    
    func logUserIn(withEmail email: String, password: String, handler: @escaping (AuthDataResult?, Error?) -> Void) {

    Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }

    func registerUser(credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        let email = credentials.email
        let password = credentials.password
        let fullname = credentials.fullname
        let username = credentials.username
        
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        let filename = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(filename)
        
        
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let uid = result?.user.uid else {return}
                    
                    let values = ["email": email, "username": username, "fullname": fullname, "profileImageUrl": profileImageUrl]
                    
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
                        
                    }
                }
                
            }
        }
    }

