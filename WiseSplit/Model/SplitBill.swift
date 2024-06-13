//
//  SplitBill.swift
//  WiseSplit
//
//  Created by beni garcia on 28/05/24.
//

import Foundation
import UIKit

struct SplitBill {
    let title: String
    let date: Date
    var total: Int
    var image: UIImage?
    let imageUrl: String
    var personTotals: [PersonTotal]
    let ownerId: String
    var paymentInfo: PaymentInfo?
}

struct PaymentInfo {
    let paymentMethod: String
    let accountName: String
    let accountNumber: String
}

struct PersonTotal {
    let personUUID: String
    let personName: String
    let personPhoneNumber: String
    var totalAmount: Int
    var items: [BillItem]
    var isPaid: Bool
    var imagePaid: UIImage?
    var imagePaidUrl: String
}

struct BillItem {
    let name: String
    let quantity: Int
    let price: Int
    
    init(name: String, quantity: Int, price: Int) {
        self.name = name
        self.quantity = quantity
        self.price = price
    }
}

extension BillItem {
    func toDictionary() -> [String: Any] {
        return [
            "name": name,
            "quantity": quantity,
            "price": price
        ]
    }
}

extension PersonTotal {
    func toDictionary() -> [String: Any] {
        return [
            "personUUID": personUUID,
            "personName": personName,
            "personPhoneNumber": personPhoneNumber,
            "totalAmount": totalAmount,
            "items": items.map { $0.toDictionary() },
            "isPaid": isPaid,
            "imagePaidUrl": imagePaidUrl,
        ]
    }
}

extension SplitBill {
    func toDictionary(imageUrl: String) -> [String: Any] {
        return [
            "title": title,
            "date": date,
            "total": total,
            "imageUrl": imageUrl,
            "ownerId": ownerId,
            "personTotals": personTotals.map { $0.toDictionary() }
        ]
    }
}

extension PaymentInfo {
    func toDictionary() -> [String: Any] {
        return [
            "paymentMethod": paymentMethod,
            "accountName": accountName,
            "accountNumber": accountNumber,
        ]
    }
}
