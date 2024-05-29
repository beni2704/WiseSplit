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
    }
    
    init(id: String, amount: Int, category: String, date: Date) {
        self.id = id
        self.amount = amount
        self.category = category
        self.date = date
    }
}
