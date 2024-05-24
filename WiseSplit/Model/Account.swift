//
//  User.swift
//  WiseSplit
//
//  Created by beni garcia on 14/03/24.
//

import Foundation

struct Account {
    let nickname: String
    let phone: String
    var budget = 0
    var transactions: [TransactionUser] = []
    
    init(nickname: String, phone: String, budget: Int, transactions: [TransactionUser] = []) {
        self.nickname = nickname
        self.phone = phone
        self.budget = budget
        self.transactions = transactions
    }
    
    init(nickname: String, phone: String) {
        self.nickname = nickname
        self.phone = phone
    }
}
