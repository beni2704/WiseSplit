//
//  Color.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import Foundation
import UIKit

extension UIColor {
    static var grayCustom = UIColor(hex: "#999999")
    static var darkGrayCustom = UIColor(hex: "#656565")
    static var yellowCustom = UIColor(hex: "#FF9820")
    static var blueButtonCustom = UIColor(hex: "#007AFF")
    static var grayBgFormCustom = UIColor(hex: "#EEEEEE")
    static var greenCustom = UIColor(hex: "#30DB5B")
    static var redCustom = UIColor(hex: "#DE0000")
    static var lightGrayCustom = UIColor(hex: "#D9D9D9")
    
    convenience init?(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
                return nil
            }

            let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            let blue = CGFloat(rgb & 0x0000FF) / 255.0

            self.init(red: red, green: green, blue: blue, alpha: 1.0)
        }
}
