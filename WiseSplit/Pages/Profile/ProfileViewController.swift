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
    var changeTheme = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileVM.fetchAccount { res in
            self.usernameLabel.text = res.nickname
        }
        setupViews()
    }
    
    func setupViews() {
        titleLabel.text = "Profile"
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        usernameLabel.font = .preferredFont(forTextStyle: .title2)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        
        emailLabel.text = "\(Auth.auth().currentUser?.phoneNumber ?? "Guest")"
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailLabel)
        
        changeTheme.setTitle("Change Theme", for: .normal)
        changeTheme.addTarget(self, action: #selector(changeThemes), for: .touchUpInside)
        changeTheme.backgroundColor = .gray
        changeTheme.translatesAutoresizingMaskIntoConstraints = false
        changeTheme.layer.cornerRadius = 8
        view.addSubview(changeTheme)
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutButton.backgroundColor = .red
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.layer.cornerRadius = 8
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            usernameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            changeTheme.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 32),
            changeTheme.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            changeTheme.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            logoutButton.topAnchor.constraint(equalTo: changeTheme.bottomAnchor, constant: 16),
            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
        
    }
    
    @objc func changeThemes() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let interfaceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        if interfaceStyle == .light {
            window?.overrideUserInterfaceStyle = .dark
            UserDefaults.standard.setValue("dark", forKey: "Theme")
        } else {
            window?.overrideUserInterfaceStyle = .light
            UserDefaults.standard.setValue("light", forKey: "Theme")
        }
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
