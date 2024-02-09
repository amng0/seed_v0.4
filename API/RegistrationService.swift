import Foundation
import Combine
import Firebase
import FirebaseDatabase
import FirebaseAuth

// These are the keys that we will be storing in firebase realtime database.

enum UserRegistrationKeys: String {
    case email
    case firstName
    case lastName
    case username
    case profileImageUrl
}

protocol RegistrationService {
    func register(with details: UserRegistrationInfo, profileImage: UIImage) -> AnyPublisher<Void, Error>
}

final class RegistrationServiceController: RegistrationService {
    func register(with details: UserRegistrationInfo, profileImage: UIImage) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { [weak self] promise in
                self?.uploadProfileImage(profileImage) { result in
                    switch result {
                    case .success(let imageUrl):
                        self?.createUser(with: details, profileImageUrl: imageUrl, completion: promise)
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

    private func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {
            completion(.failure(NSError(domain: "Image Conversion Failed", code: 0, userInfo: nil)))
            return
        }

        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images/\(filename)")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let imageUrl = url?.absoluteString else {
                    completion(.failure(NSError(domain: "URL Conversion Failed", code: 0, userInfo: nil)))
                    return
                }

                completion(.success(imageUrl))
            }
        }
    }

    private func createUser(with details: UserRegistrationInfo, profileImageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: details.email, password: details.password) { res, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let uid = res?.user.uid else {
                completion(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
                return
            }

            let values = [
                UserRegistrationKeys.firstName.rawValue: details.firstName,
                UserRegistrationKeys.lastName.rawValue: details.lastName,
                UserRegistrationKeys.username.rawValue: details.username,
                UserRegistrationKeys.email.rawValue: details.email,
                UserRegistrationKeys.profileImageUrl.rawValue: profileImageUrl,
                "uid": uid // Add the UID as a value
            ] as [String: Any]

            Database.database().reference().child("users").child(uid).updateChildValues(values) { error, _ in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
}


// Clean up the database in the future under the UserDetails node

//private func createUser(with details: UserRegistrationInfo, profileImageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
//    Auth.auth().createUser(withEmail: details.email, password: details.password) { res, error in
//        if let error = error {
//            completion(.failure(error))
//            return
//        }
//
//        guard let uid = res?.user.uid else {
//            completion(.failure(NSError(domain: "Invalid User Id", code: 0, userInfo: nil)))
//            return
//        }
//
//        let userDetails = [
//            UserRegistrationKeys.firstName.rawValue: details.firstName,
//            UserRegistrationKeys.lastName.rawValue: details.lastName,
//            UserRegistrationKeys.username.rawValue: details.username,
//            UserRegistrationKeys.email.rawValue: details.email,
//            UserRegistrationKeys.profileImageUrl.rawValue: profileImageUrl
//        ] as [String: Any]
//
//        let values = ["userDetails": userDetails, "uid": uid] // Create a "userDetails" node and include the UID
//        Database.database().reference().child("users").child(uid).updateChildValues(values) { error, _ in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//}

