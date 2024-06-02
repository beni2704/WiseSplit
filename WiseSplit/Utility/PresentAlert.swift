//
//  PresentAlert.swift
//  WiseSplit
//
//  Created by beni garcia on 01/06/24.
//

import Foundation
import UIKit

func presentingAlert(title: String, message: String, view: UIViewController) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    view.present(alert, animated: true, completion: nil)
}
