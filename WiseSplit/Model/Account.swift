//
//  User.swift
//  WiseSplit
//
//  Created by beni garcia on 14/03/24.
//

import Foundation

struct Account {
    let nickname: String
    let email: String
    var budget = 0
    var transactions: [TransactionUser] = []
    
    init(nickname: String, email: String, budget: Int, transactions: [TransactionUser] = []) {
        self.nickname = nickname
        self.email = email
        self.budget = budget
        self.transactions = transactions
    }
    
    init(nickname: String, email: String) {
        self.nickname = nickname
        self.email = email
    }
}
