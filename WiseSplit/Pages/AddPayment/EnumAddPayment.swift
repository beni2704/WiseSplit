//
//  EnumAddPayment.swift
//  WiseSplit
//
//  Created by beni garcia on 26/04/24.
//

import Foundation

enum AddPaymentError: Error{
    case emptyField
    case invalidAmount
    case insufficientAmount
}
