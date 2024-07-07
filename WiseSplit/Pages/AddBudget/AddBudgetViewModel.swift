//
//  AddBudgetViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddBudgetViewModel {
    public func addBudget(amount: Int, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(NSError(domain: "Authentication", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"]))
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        if checkAmount(amount: amount) {
            return completion(AddBudgetError.invalidAmount)
        }
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(error)
            } else if let document = document, document.exists {
                let data = document.data()
                var currentBudget = data?["budget"] as? Int ?? 0
                currentBudget += amount
                
                userRef.updateData(["budget": currentBudget]) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
                
                let transactionRef = userRef.collection("transactions").document()
                
                let dataTrans: [String: Any] = [
                    "category": "Income",
                    "amount": amount,
                    "date": Timestamp(date: Date.now)
                ]
                
                transactionRef.setData(dataTrans) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found"]))
            }
        }
    }
    
    public func checkAmount(amount: Int) -> Bool {
        if amount <= 0 {
            return true
        }
        return false
    }
}
