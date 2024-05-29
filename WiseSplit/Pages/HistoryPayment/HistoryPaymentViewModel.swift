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
    
    func fetchTransactionsSpending(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                        if transaction.category == "Bill Owe" || transaction.category == "Bill Received" || transaction.category == "Income"{
                            continue
                        }
                        transactions.append(transaction)
                    }
                }
                completion(.success(transactions))
            }
        }
    }
    
    func fetchTransactionsBillOwe(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                        if transaction.category == "Bill Owe"{
                            transactions.append(transaction)
                        }
                    }
                }
                completion(.success(transactions))
            }
        }
    }
    
    func fetchTransactionsBillReceived(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                        if transaction.category == "Bill Received" {
                            transactions.append(transaction)
                        }
                    }
                }
                completion(.success(transactions))
            }
        }
    }
}
