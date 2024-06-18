//
//  RegisterViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import Foundation
import UIKit

class RegisterViewController: BaseViewController {
    var registerVM: RegisterViewModel?
    var logoApp = UIImageView()
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var nicknameLabel = UILabel()
    var nicknameTF = PaddedTextField()
    var phoneLabel = UILabel()
    var phoneTF = PaddedTextField()
    var messageLabel = UILabel()
    var registerButton = UIButton()
    var loginButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        registerVM = RegisterViewModel()
        setAll()
    }
    
    func setAll() {
        logoApp.image = UIImage(systemName: "leaf.fill")
        logoApp.tintColor = Colors.base
        logoApp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoApp)
        
        titleLabel.addCharactersSpacing(spacing: 12, text: "Wise\nWallet")
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "Register your account"
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subTitleLabel.textColor = .gray
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
        nicknameLabel.text = "Nickname (e.g Beni)"
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.font = .preferredFont(forTextStyle: .callout)
        view.addSubview(nicknameLabel)
        
        nicknameTF.placeholder = "Nickname"
        nicknameTF.borderStyle = .none
        nicknameTF.backgroundColor = Colors.backgroundFormCustom
        nicknameTF.layer.cornerRadius = 8
        nicknameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTF)
        
        phoneLabel.text = "Phone (e.g +6281389971674)"
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.font = .preferredFont(forTextStyle: .callout)
        view.addSubview(phoneLabel)
        
        phoneTF.placeholder = "Phone Number"
        phoneTF.borderStyle = .none
        phoneTF.backgroundColor = Colors.backgroundFormCustom
        phoneTF.layer.cornerRadius = 8
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneTF)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 12
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        loginButton.setTitle("Already have an account?", for: .normal)
        loginButton.setTitleColor(Colors.base, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        messageLabel.text = ""
        messageLabel.textColor = Colors.redCustom
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            logoApp.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            logoApp.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -250),
            logoApp.heightAnchor.constraint(equalToConstant: 64),
            logoApp.widthAnchor.constraint(equalToConstant: 64),
            
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.topAnchor.constraint(equalTo: logoApp.bottomAnchor, constant: 24),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nicknameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 250),
            
            nicknameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            nicknameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            nicknameTF.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 4),
            nicknameTF.heightAnchor.constraint(equalToConstant: 44),
            
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            phoneLabel.topAnchor.constraint(equalTo: nicknameTF.bottomAnchor, constant: 16),
            phoneLabel.widthAnchor.constraint(equalToConstant: 250),
            
            phoneTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            phoneTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            phoneTF.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4),
            phoneTF.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            registerButton.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 24),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            messageLabel.widthAnchor.constraint(equalToConstant: 250),
            
        ])
    }
    
    @objc func registerButtonTapped() {
        guard let nickname = nicknameTF.text, let phone = phoneTF.text, let registerVM = registerVM else {
            return
        }
        
        if !registerVM.validateNickname(nickname) {
            messageLabel.text = "Nickname must be 4 - 12 length"
            return
        }
        
        if !registerVM.validatePhone(phone) {
            messageLabel.text = "Please enter your correct phone number"
            return
        }
        
        self.addLoading(onView: self.view)
        let newAcc = Account(nickname: nickname, phone: phone)
        
        registerVM.registerUserIfNotExists(account: newAcc) { success in
            if success {
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(OTPViewController(account: newAcc), animated: true)
                }
            } else {
                self.messageLabel.text = "Phone number already registered"
                self.removeLoading()
            }
        }
    }
    
    @objc func loginButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(LoginViewController(), animated: true)
        }
    }
}
