//
//  RegisterViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var nicknameTF = UITextField()
    var phoneTF = UITextField()
    var passwordTF = UITextField()
    var passwordConfirmTF = UITextField()
    var buttonRegister = UIButton()
    var errorLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        passwordConfirmTF.placeholder = "Confirm Password"
        passwordConfirmTF.borderStyle = .roundedRect
        passwordConfirmTF.layer.borderColor = UIColor.blue.cgColor
        passwordConfirmTF.layer.borderWidth = 1.0
        passwordConfirmTF.layer.cornerRadius = 8
        passwordConfirmTF.isSecureTextEntry = true
        passwordConfirmTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordConfirmTF)
        
        buttonRegister.setTitle("Register", for: .normal)
        buttonRegister.backgroundColor = .systemBlue
        buttonRegister.layer.cornerRadius = 8
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
            
            passwordConfirmTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordConfirmTF.topAnchor.constraint(equalTo: passwordTF.bottomAnchor, constant: 14),
            passwordConfirmTF.widthAnchor.constraint(equalToConstant: 250),
            passwordConfirmTF.heightAnchor.constraint(equalToConstant: 44),
            
            buttonRegister.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonRegister.topAnchor.constraint(equalTo: passwordConfirmTF.bottomAnchor, constant: 14),
            buttonRegister.widthAnchor.constraint(equalToConstant: 250),
            buttonRegister.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
}
