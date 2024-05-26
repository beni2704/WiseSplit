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
        titleLabel.text = "Wise Wallet"
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "Register your account"
        subTitleLabel.font = .preferredFont(forTextStyle: .title2)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
        nicknameLabel.text = "Nickname (e.g Beni)"
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.font = .preferredFont(forTextStyle: .callout)
        view.addSubview(nicknameLabel)
        
        nicknameTF.placeholder = "Nickname"
        nicknameTF.borderStyle = .none
        nicknameTF.backgroundColor = .grayBgFormCustom
        nicknameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTF)
        
        phoneLabel.text = "Phone (e.g +6281389971674)"
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.font = .preferredFont(forTextStyle: .callout)
        view.addSubview(phoneLabel)
        
        phoneTF.placeholder = "Phone Number"
        phoneTF.borderStyle = .none
        phoneTF.backgroundColor = .grayBgFormCustom
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneTF)
        
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
            
            nicknameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14),
            nicknameLabel.widthAnchor.constraint(equalToConstant: 250),
            
            nicknameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameTF.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 7),
            nicknameTF.widthAnchor.constraint(equalToConstant: 250),
            nicknameTF.heightAnchor.constraint(equalToConstant: 44),
            
            phoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneLabel.topAnchor.constraint(equalTo: nicknameTF.bottomAnchor, constant: 14),
            phoneLabel.widthAnchor.constraint(equalToConstant: 250),
            
            phoneTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTF.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 7),
            phoneTF.widthAnchor.constraint(equalToConstant: 250),
            phoneTF.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 14),
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
