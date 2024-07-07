//
//  ProfileViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 02/04/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileViewModel {
    public func fetchAccount(completion: @escaping (Account) -> Void) {
        var db = Firestore.firestore()
        var account = Account(nickname: "null", phone: "null", budget: 0)
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(account)
            return
        }
        
        let userRef = db.collection("users").document(currentUserUID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let nickname = data?["nickname"] as? String ?? "null"
                let phone = data?["phone"] as? String ?? "null"
                let budget = data?["budget"] as? Int ?? 0
                account = Account(nickname: nickname, phone: phone, budget: budget)
            } else {
                print("User document not found")
            }
            
            completion(account)
        }
    }
    
    public func logoutUser(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
