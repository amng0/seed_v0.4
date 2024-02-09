////
////  TestViewModel.swift
////  seed_v0.4
////
////  Created by Amie Nguyen on 11/13/23.
////
//
//import FirebaseAuth
//import FirebaseDatabase
//
//final class TestViewModel: ObservableObject{
//
//    @Published var hoes: [Hoes] = []
//    
//    private lazy var databasePath: DatabaseReference? = {
//      // 1
//      guard let uid = Auth.auth().currentUser?.uid else {
//        return nil
//      }
//
//      // 2
//      let ref = Database.database()
//        .reference().child("goalPosts")
//      return ref
//    }()
//
//    // 3
//    private let encoder = JSONEncoder()
//}
//
//func postThought(){
//    guard let databasePath = databasePath else {
//        return
//    }
//    
////    if newThoughtText.isEmpty{
//        return
//    }
//    
//    let thought = 
//    
//}
