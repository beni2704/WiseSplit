//
//  HomeViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 23/04/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class HomeViewModel: ObservableObject {
    private var db = Firestore.firestore()
    @Published var spentCategories = [TransactionUser]()
    
    func fetchAccount(completion: @escaping (Account) -> Void) {
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
    
    func fetchTransaction(completion: @escaping () -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        db.collection("users").document(currentUserUID).collection("transactions").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            } else {
                for document in querySnapshot!.documents {
                    if let transaction = TransactionUser(document: document) {
                        var category = transaction.category
                        if category == "Income" {
                            category = "Income"
                        }else if category != "Health Care" {
                            category = "Spending"
                        }
                        var amount = abs(transaction.amount)
                        
                        let newTrans = TransactionUser(id: transaction.id, amount: amount, category: category, date: transaction.date)
                        
                        self.spentCategories.append(newTrans)
                    }
                }
                completion()
            }
        }
        
    }
}
