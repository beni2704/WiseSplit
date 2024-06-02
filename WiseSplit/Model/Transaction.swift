//
//  Transaction.swift
//  WiseSplit
//
//  Created by beni garcia on 03/05/24.
//

import Foundation
import FirebaseFirestore

struct TransactionUser: Identifiable{
    let id: String
    let amount: Int
    let category: String
    let date: Date
    var splitBillId: String?
    
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let amount = data["amount"] as? Int,
              let category = data["category"] as? String,
              let timestamp = data["date"] as? Timestamp else {
            return nil
        }
        
        self.id = document.documentID
        self.amount = amount
        self.category = category
        self.date = timestamp.dateValue()
        
        if let data = document.data(), let splitBillId = data["splitBillUID"] as? String {
            self.splitBillId = splitBillId
        }
        
        
    }
    
    init(id: String, amount: Int, category: String, date: Date) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
    }
    
    init(id: String, amount: Int, category: String, date: Date, splitBillId: String) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
        self.splitBillId = splitBillId
    }
}
