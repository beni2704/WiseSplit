//
//  RegisterViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    var registerVM: RegisterViewModel?
    
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var nicknameTF = UITextField()
    var phoneTF = UITextField()
    var passwordTF = UITextField()
    var confirmPasswordTF = UITextField()
    var buttonRegister = UIButton()
    var errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerVM = RegisterViewModel()
        setAll()
    }
    
    func setAll() {
        titleLabel.text = "Wise Split"
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "Register your account"
        subTitleLabel.font = .preferredFont(forTextStyle: .title2)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
        nicknameTF.placeholder = "Nickname"
        nicknameTF.borderStyle = .roundedRect
        nicknameTF.layer.borderColor = UIColor.blue.cgColor
        nicknameTF.layer.borderWidth = 1.0
        nicknameTF.layer.cornerRadius = 8
        nicknameTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTF)
        
        phoneTF.placeholder = "Phone Number"
        phoneTF.borderStyle = .roundedRect
        phoneTF.layer.borderColor = UIColor.blue.cgColor
        phoneTF.layer.borderWidth = 1.0
        phoneTF.layer.cornerRadius = 8
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneTF)
        
        passwordTF.placeholder = "Password"
        passwordTF.borderStyle = .roundedRect
        passwordTF.layer.borderColor = UIColor.blue.cgColor
        passwordTF.layer.borderWidth = 1.0
        passwordTF.layer.cornerRadius = 8
        passwordTF.isSecureTextEntry = true
        passwordTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTF)
        
        confirmPasswordTF.placeholder = "Confirm Password"
        confirmPasswordTF.borderStyle = .roundedRect
        confirmPasswordTF.layer.borderColor = UIColor.blue.cgColor
        confirmPasswordTF.layer.borderWidth = 1.0
        confirmPasswordTF.layer.cornerRadius = 8
        confirmPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(confirmPasswordTF)
        
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.backgroundColor = .systemBlue
        buttonRegister.layer.cornerRadius = 8
        buttonRegister.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonRegister)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            
            nicknameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nicknameTF.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14),
            nicknameTF.widthAnchor.constraint(equalToConstant: 250),
            nicknameTF.heightAnchor.constraint(equalToConstant: 44),
            
            phoneTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTF.topAnchor.constraint(equalTo: nicknameTF.bottomAnchor, constant: 14),
            phoneTF.widthAnchor.constraint(equalToConstant: 250),
            phoneTF.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTF.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 14),
            passwordTF.widthAnchor.constraint(equalToConstant: 250),
            passwordTF.heightAnchor.constraint(equalToConstant: 44),
            
            confirmPasswordTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordTF.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 14),
            confirmPasswordTF.widthAnchor.constraint(equalToConstant: 250),
            confirmPasswordTF.heightAnchor.constraint(equalToConstant: 44),
            
            buttonRegister.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonRegister.topAnchor.constraint(equalTo: confirmPasswordTF.bottomAnchor, constant: 14),
            buttonRegister.widthAnchor.constraint(equalToConstant: 250),
            buttonRegister.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc func registerButtonTapped() {
        guard let nickname = nicknameTF.text, let phone = phoneTF.text, let password = passwordTF.text, let confirmPassword = confirmPasswordTF.text else {
            return
        }
        var message = registerVM?.registerAccount(nickname: nickname, phoneNumber: phone, password: password, confirmPassword: confirmPassword)
        
        if message == 1 {
            //sucess register
        }else {
            //gagal register
        }
    }
}
