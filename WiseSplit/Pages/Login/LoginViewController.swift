//
//  LoginViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 22/03/24.
//

import Foundation
import UIKit

class LoginViewController: BaseViewController {
    var loginVM: LoginViewModel?
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var emailTF = PaddedTextField()
    var passwordTF = PaddedTextField()
    var messageLabel = UILabel()
    var loginButton = UIButton()
    var registerButton = UIButton()
    var successMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loginVM = LoginViewModel()
        setAll()
        
        if let successMessage = successMessage {
            showSuccessMessage(successMessage)
        }
    }
    
    func setAll() {
        titleLabel.text = "Wise Wallet"
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "Login to your account"
        subTitleLabel.font = .preferredFont(forTextStyle: .title2)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
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
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 8
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        registerButton.setTitle("Don't have an account yet?", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        messageLabel.text = ""
        messageLabel.textColor = .red
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            emailTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTF.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14),
            emailTF.widthAnchor.constraint(equalToConstant: 250),
            emailTF.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: emailTF.bottomAnchor, constant: 14),
            passwordTF.widthAnchor.constraint(equalToConstant: 250),
            passwordTF.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 14),
            loginButton.widthAnchor.constraint(equalToConstant: 250),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 14),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 14),
            messageLabel.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    @objc func registerButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(RegisterViewController(), animated: true)
        }
    }
    
    @objc func loginButtonTapped() {
        guard let email = emailTF.text, let password = passwordTF.text else {
            return
        }
        self.addLoading(onView: self.view)
        loginVM?.checkEmailExists(email: email) { [weak self] exists in
            guard let self = self else { return }
            if exists {
                self.loginVM?.loginUser(email: email, password: password) { result in
                    switch result {
                    case .success(_):
                        DispatchQueue.main.async {
                            self.navigateToHome()
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.showErrorMessage("Email or password wrong")
                        }
                    }
                }
            } else {
                self.showErrorMessage("Email is not registered.")
            }
        }
        self.removeLoading()
    }
    
    private func navigateToHome() {
        let homeVC = TabBarController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func showErrorMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .redCustom
    }
    
    private func showSuccessMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .greenCustom
    }
}
