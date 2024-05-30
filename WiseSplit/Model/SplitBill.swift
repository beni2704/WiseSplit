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
    let total: Int
    var image: UIImage?
    let imageUrl: String
    let personTotals: [PersonTotal]
}

struct PersonTotal {
    let personUUID: String
    let personName: String
    let totalAmount: Int
    let items: [BillItem]
    var isPaid: Bool
}

struct BillItem {
    let name: String
    let quantity: Int
    let price: Int
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
            "totalAmount": totalAmount,
            "items": items.map { $0.toDictionary() },
            "isPaid": isPaid
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
            "personTotals": personTotals.map { $0.toDictionary() }
        ]
    }
}