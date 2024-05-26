//
//  ProfileViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 02/04/24.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    var profileVM = ProfileViewModel()
    var titleLabel = UILabel()
    var usernameLabel = UILabel()
    var emailLabel = UILabel()
    var logoutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        titleLabel.text = "Profile"
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        usernameLabel.text = "Beni"
        usernameLabel.font = .preferredFont(forTextStyle: .title2)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        
        emailLabel.text = "\(Auth.auth().currentUser?.email ?? "Guest")"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 64),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 16),
            
        ])
        
    }
    
    @objc private func logoutButtonTapped() {
        profileVM.logoutUser { [weak self] success in
            guard let self = self else { return }
            if success {
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(LoginViewController(), animated: true)
                }
            }
        }
    }
}
