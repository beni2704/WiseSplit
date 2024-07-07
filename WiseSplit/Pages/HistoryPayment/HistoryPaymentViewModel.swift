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
    private let db = Firestore.firestore()
    
    public func fetchTransactionsSpending(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                        if transaction.category == "Split Bill Owe" || transaction.category == "Split Bill Received" || transaction.category == "Income"{
                            continue
                        }
                        transactions.append(transaction)
                    }
                }
                completion(.success(transactions.reversed()))
            }
        }
    }
    
    public func fetchTransactionIncome(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                        if transaction.category == "Income"{
                            transactions.append(transaction)
                        }
                    }
                }
                completion(.success(transactions.reversed()))
            }
        }
    }
    
    public func fetchTransactionsBillOwe(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                        if transaction.category == "Split Bill Owe"{
                            transactions.append(TransactionUser(id: transaction.id, amount: (transaction.amount) * -1, category: transaction.category, date: transaction.date, splitBillId: transaction.splitBillId ?? "empty"))
                        }
                    }
                }
                completion(.success(transactions.reversed()))
            }
        }
    }
    
    public func fetchTransactionsBillReceived(completion: @escaping (Result<[TransactionUser], Error>) -> Void) {
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
                let group = DispatchGroup()
                
                for document in snapshot!.documents {
                    if let transaction = TransactionUser(document: document), transaction.category == "Split Bill Received" {
                        let splitBillId = transaction.splitBillId ?? "empty"
                        
                        group.enter()
                        let splitBillRef = self.db.collection("splitBills").document(splitBillId)
                        splitBillRef.getDocument { splitBillSnapshot, splitBillError in
                            if let splitBillError = splitBillError {
                                completion(.failure(splitBillError))
                            } else {
                                if let splitBillData = splitBillSnapshot?.data(),
                                   let total = splitBillData["total"] as? Int {
                                    let calculatedAmount = total - transaction.amount
                                    transactions.append(TransactionUser(id: transaction.id, amount: calculatedAmount, category: transaction.category, date: transaction.date, splitBillId: splitBillId))
                                }
                            }
                            group.leave()
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(transactions.reversed()))
                }
            }
        }
    }
    
    
}
