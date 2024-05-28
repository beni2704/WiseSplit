//
//  AddPaymentViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddPaymentViewModel {
    let db = Firestore.firestore()
    
    func addPayment(amount: Int, category: String, date: Date, completion: @escaping (Error?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        if (checkFormat(amount: amount, category: category, date: date) != nil) {
            return completion(checkFormat(amount: amount, category: category, date: date))
        }
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(error)
            } else if let document = document, document.exists {
                let data = document.data()
                var currentBudget = data?["budget"] as? Int ?? 0
                
                if amount > currentBudget {
                    completion(AddPaymentError.insufficientAmount)
                    return
                }
                currentBudget -= amount
                
                userRef.updateData(["budget": currentBudget]) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        // Proceed with transaction addition only after budget update is successful
                        let transactionRef = userRef.collection("transactions").document()
                        
                        let data: [String: Any] = [
                            "amount": -amount,
                            "category": category,
                            "date": Timestamp(date: date)
                        ]
                        
                        transactionRef.setData(data) { error in
                            if let error = error {
                                completion(error)
                            } else {
                                completion(nil)
                            }
                        }
                    }
                }
            } else {
                completion(NSError(domain: "Firestore", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found"]))
            }
        }
    }
    
    func checkFormat(amount: Int, category: String, date: Date) -> Error? {
        if amount.words.isEmpty || category.isEmpty || date.description.isEmpty {
            return (AddPaymentError.emptyField)
        }
        if amount <= 0 {
            return (AddPaymentError.invalidAmount)
        }
        return nil
    }
}
