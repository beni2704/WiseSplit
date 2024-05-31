//
//  ResultSplitBillViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit

class ResultViewModel {
    
    var displayedUsers: [PersonTotal]
    var billName: String
    
    init(displayedUsers: [PersonTotal], billName: String) {
        self.displayedUsers = displayedUsers
        self.billName = billName
    }
    
    // MARK: - Labels and UI Elements
    
    var titleLabelText: String {
        return "Total Amount"
    }
    
    var firstLabelText: String {
        return billName
    }
    
    var secondLabelText: String {
        return "Bill Date"
    }
    
    // MARK: - UI Setup Methods
    
    func setupBackgroundView(_ backgroundView: UIView) {
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 10
    }
    
    func setupScrollView(_ scrollView: UIScrollView, in backgroundView: UIView) {
        scrollView.backgroundColor = .lightGray
        scrollView.layer.cornerRadius = 10
        scrollView.showsVerticalScrollIndicator = true // Enable vertical scroll indicator
        backgroundView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -287)
        ])
    }
    
    // MARK: - Display Users
    
    func userNameText(for user: PersonTotal) -> String {
        let formattedTotalOwe = String(format: "%.2f", user.totalAmount)
        return "\(user.personName)'s total: \(formattedTotalOwe)"
    }
    
    func userPhoneNumberText(for user: PersonTotal) -> String {
        return "\(user.personPhoneNumber)"
    }
    
    func userStatusButtonText(for user: PersonTotal) -> String {
        return user.isPaid ? "See Payment" : "Unpaid"
    }
    
    func userStatusButtonColor(for user: PersonTotal) -> UIColor {
        return user.isPaid ? .green : .gray
    }
    
    func userStatusButtonEnabled(for user: PersonTotal) -> Bool {
        return user.isPaid
    }
}
