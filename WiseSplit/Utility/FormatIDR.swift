//
//  Formatter.swift
//  WiseSplit
//
//  Created by beni garcia on 26/05/24.
//

import Foundation

func formatToIDR(_ amount: Int) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.maximumFractionDigits = 0
    return formatter.string(from: NSNumber(value: amount)) ?? "Rp 0"
}


