//
//  ShowSheet.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit

func showSheet(vc: UIViewController, presentingVC: UIViewController) {
    let viewController = vc
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .pageSheet
    
    if let sheet = navigationController.sheetPresentationController {
        sheet.detents = [.medium(), .large()]
        sheet.prefersGrabberVisible = true
    }
    
    presentingVC.present(navigationController, animated: true, completion: nil)
}
