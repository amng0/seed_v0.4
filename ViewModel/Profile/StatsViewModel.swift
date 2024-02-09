//  StatsViewModel.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 8/26/23.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase
import SwiftUI

class StatsViewModel: ObservableObject {
    
    @Published var stats: [Stat] = []
    @Published var fetchedStats: [Stat] = []
    
    func setupAuth(stat: Stat) {
        // safely unwrap userID using firebase Auth
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        uploadStat(with: userID, stat: stat)
    }
    
    func addStat(stat: Stat) {
        // safely unwrap userID using firebase Auth
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        uploadStat(with: userID, stat: stat)
        fetchStats()
    }
    
    // Upload a goal post to realtime database. First, encode the goalPost object into JSON, transformed into a dictionary using JSONSerialization as [String: Any]. Use of updateChildValues to also update the board object if board values are changed.
    func uploadStat(with uid: String, stat: Stat){
        let firebaseRef = Database.database().reference()
        let data = try? JSONEncoder().encode(stat)
        
        if let data = data, let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            
            let statRef = firebaseRef.child("users").child(uid).child("stats").child("\(stat.id)")
            
            statRef.updateChildValues(jsonDict) { (error, ref) in
                if let error = error {
                    print("Error updating data: \(error.localizedDescription)")
                }
            }
        }
    }
    
    //  Fetches all stats associated with the currently signed in user
    func fetchStats() {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference().child("users").child(userID).child("stats")
        
        print(userID)
        print(ref)
        
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let self = self else { return }
            
            do {
                if snapshot.exists(), let statDict = snapshot.value as? [String: Any] {
                    let data = try JSONSerialization.data(withJSONObject: statDict, options: [])
                    let fetchedStats = try JSONDecoder().decode([String: Stat].self, from: data)
                    
                    let stats = Array(fetchedStats.values)
                    
                    DispatchQueue.main.async {
                        self.stats = stats
                        print("DEBUG: fetched goals \(fetchedStats)")
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.stats = []
                    }
                }
            } catch {
                print("Error decoding stats:", error)
            }
        }
    }
    
    func editStat(statId: UUID, with newDetails: Stat) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let firebaseRef = Database.database().reference()
        let statRef = firebaseRef.child("users").child(userID).child("stats").child("\(statId)")

        let updatedData = try? JSONEncoder().encode(newDetails)
        if let updatedData = updatedData, let jsonDict = try? JSONSerialization.jsonObject(with: updatedData, options: []) as? [String: Any] {
            statRef.updateChildValues(jsonDict) { [weak self] (error, ref) in
                if let error = error {
                    print("Error updating stat data: \(error.localizedDescription)")
                } else {
                    self?.fetchStats() // Fetch updated stats
                }
            }
        }
    }
    
    func deleteStat(statId: UUID) {
        guard let userID = Auth.auth().currentUser?.uid else {
            return
        }

        let firebaseRef = Database.database().reference()
        let statRef = firebaseRef.child("users").child(userID).child("stats").child("\(statId)")

        statRef.removeValue { error, _ in
            if let error = error {
                print("Error deleting stat: \(error.localizedDescription)")
            } else {
                // Handle successful deletion, e.g., update UI, notify user, etc.
                self.fetchedStats // Optionally refresh goal posts after deletion
            }
        }
    }
}
