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
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var nicknameTF = PaddedTextField()
    var emailTF = PaddedTextField()
    var passwordTF = PaddedTextField()
    var confirmPasswordTF = PaddedTextField()
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
        titleLabel.text = "Wise Wallet"
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "Register your account"
        subTitleLabel.font = .preferredFont(forTextStyle: .title2)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
        nicknameTF.placeholder = "Nickname"
        nicknameTF.borderStyle = .none
        nicknameTF.backgroundColor = .grayBgFormCustom
        nicknameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTF)
        
        emailTF.placeholder = "Email"
        emailTF.borderStyle = .none
        emailTF.backgroundColor = .grayBgFormCustom
        emailTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTF)
        
        passwordTF.placeholder = "Password"
        passwordTF.borderStyle = .none
        passwordTF.backgroundColor = .grayBgFormCustom
        passwordTF.isSecureTextEntry = true
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTF)
        
        confirmPasswordTF.placeholder = "Confirm Password"
        confirmPasswordTF.borderStyle = .none
        confirmPasswordTF.backgroundColor = .grayBgFormCustom
        confirmPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPasswordTF)
        
        registerButton.setTitle("Register", for: .normal)
        registerButton.backgroundColor = .systemBlue
        registerButton.layer.cornerRadius = 8
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        loginButton.setTitle("Already have an account?", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        messageLabel.text = ""
        messageLabel.textColor = .redCustom
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            nicknameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameTF.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14),
            nicknameTF.widthAnchor.constraint(equalToConstant: 250),
            nicknameTF.heightAnchor.constraint(equalToConstant: 44),
            
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTF.topAnchor.constraint(equalTo: nicknameTF.bottomAnchor, constant: 14),
            emailTF.widthAnchor.constraint(equalToConstant: 250),
            emailTF.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 14),
            passwordTF.widthAnchor.constraint(equalToConstant: 250),
            passwordTF.heightAnchor.constraint(equalToConstant: 44),
            
            confirmPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTF.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 14),
            confirmPasswordTF.widthAnchor.constraint(equalToConstant: 250),
            confirmPasswordTF.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: confirmPasswordTF.bottomAnchor, constant: 14),
            registerButton.widthAnchor.constraint(equalToConstant: 250),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 14),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 14),
            messageLabel.widthAnchor.constraint(equalToConstant: 250),
            
        ])
    }
    
    @objc func registerButtonTapped() {
        guard let nickname = nicknameTF.text, let email = emailTF.text, let password = passwordTF.text, let confirmPassword = confirmPasswordTF.text else {
            return
        }
        if nickname.isEmpty {
            messageLabel.text = "Please enter your nickname"
            return
        }
        
        if email.isEmpty {
            messageLabel.text = "Please enter your email"
            return
        }
        
        if password.isEmpty {
            messageLabel.text = "Please enter your password"
            return
        }
        
        if confirmPassword.isEmpty {
            messageLabel.text = "Please confirm your password"
            return
        }
        
        registerVM?.registerAccount(nickname: nickname, email: email, password: password, confirmPassword: confirmPassword) { result in
            switch result {
            case .success(_):
                let loginVC = LoginViewController()
                loginVC.successMessage = "Registration successful. Please log in to your account."
                
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(loginVC, animated: true)
                }
            case .failure(let error):
                if let registerError = error as? RegisterError {
                    switch registerError {
                    case.invalidTextField :
                        self.messageLabel.text = "All fields must be filled"
                    case .invalidEmail:
                        self.messageLabel.text = "Invalid email format"
                    case .passwordMismatch:
                        self.messageLabel.text = "Password missmatch or at least must be 1 uppercase character "
                    }
                } else {
                    self.messageLabel.text = "\(error.localizedDescription)"
                }
            }
        }
    }
    
    @objc func loginButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(LoginViewController(), animated: true)
        }
    }
}
