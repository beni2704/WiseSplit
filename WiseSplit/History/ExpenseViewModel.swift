//
//  ExpenseViewModel.swift
//  WiseSplit
//
//  Created by ichiro on 25/05/24.
//

import UIKit

class ExpenseViewModel {
    private var expense: Expense
    
    init(expense: Expense) {
        self.expense = expense
    }
    
    var expenseImage: UIImage {
        return expense.expenseImage
    }
    
    var expenseName: String {
        return expense.expenseName
    }
    
    var expenseDesc: String {
        return expense.expenseDesc
    }
    
    var expensePrice: String {
        return String(format: "$%.2f", expense.expensePrice)
    }
    
    var expenseDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: expense.expenseDate)
    }
}

