//
//  HistoryPaymentViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 23/04/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class HistoryPaymentViewModel {
    let db = Firestore.firestore()
    
    func fetchTransactions(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = db.collection("users").document(userId)
        let transactionsRef = userRef.collection("transactions")
        
        transactionsRef.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else {
                var transactions: [TransactionUser] = []
                for document in snapshot!.documents {
                    if let transaction = TransactionUser(document: document) {
                        transactions.append(transaction)
                    }
                }
                completion(.success(transactions))
            }
        }
    }
}
