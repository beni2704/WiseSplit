//
//  CharacterSpacing.swift
//  WiseSplit
//
//  Created by beni garcia on 19/06/24.
//

import Foundation
import UIKit

extension UILabel {
    func addCharactersSpacing(spacing:CGFloat, text:String) {
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSMakeRange(0, text.count-1))
        self.attributedText = attributedString
    }
}
