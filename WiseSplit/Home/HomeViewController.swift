//
//  HomeViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 26/03/24.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        setupLogoutButton()
    }
    
    private func setupLogoutButton() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    @objc private func logoutButtonTapped() {
        do {
            try Auth.auth().signOut()
            navigationController?.pushViewController(LoginViewController(), animated: true)
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
