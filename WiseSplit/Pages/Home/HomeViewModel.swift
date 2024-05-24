//
//  HomeViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 23/04/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel {
    func fetchAccount(completion: @escaping (Account) -> Void) {
        var account = Account(nickname: "null", email: "null", budget: 0)
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(account)
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserUID)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let nickname = data?["nickname"] as? String ?? "null"
                let email = data?["email"] as? String ?? "null"
                let budget = data?["budget"] as? Int ?? 0
                account = Account(nickname: nickname, email: email, budget: budget)
            } else {
                print("User document not found")
            }
            
            completion(account) 
        }
    }

}
