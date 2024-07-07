//
//  LoginViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 22/03/24.
//
import UIKit

class LoginViewController: BaseViewController {
    private var loginVM: LoginViewModel?
    private var logoApp = UIImageView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var phoneLabel = UILabel()
    private var phoneTF = PaddedTextField()
    private var messageLabel = UILabel()
    private var loginButton = UIButton()
    private var registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loginVM = LoginViewModel()
        setAll()
    }
    
    private func setAll() {
        logoApp.image = UIImage(systemName: "leaf.fill")
        logoApp.tintColor = Colors.base
        logoApp.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoApp)
        
        titleLabel.addCharactersSpacing(spacing: 12, text: "Wise\nWallet")
        titleLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "Login to your account"
        subTitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subTitleLabel.textColor = .gray
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
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
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 12
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        registerButton.setTitle("Don't have an account yet?", for: .normal)
        registerButton.setTitleColor(Colors.base, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(registerButton)
        
        messageLabel.text = ""
        messageLabel.textColor = Colors.redCustom
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
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
            
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            phoneLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 16),
            phoneLabel.widthAnchor.constraint(equalToConstant: 250),
            
            phoneTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            phoneTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            phoneTF.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 4),
            phoneTF.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            loginButton.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 24),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 16),
            messageLabel.widthAnchor.constraint(equalToConstant: 250),
        ])
    }

    
    @objc private func registerButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(RegisterViewController(), animated: true)
        }
    }
    
    @objc private func loginButtonTapped() {
        // login otp sms maks 10x sehari
        guard let phoneNumber = phoneTF.text, !phoneNumber.isEmpty else {
            showErrorMessage("Please enter your phone number.")
            return
        }
        
        loginVM?.checkPhoneNumberExists(phoneNumber: phoneNumber) { [weak self] exists in
            if exists {
                self?.loginVM?.sendVerificationCode(phoneNumber: phoneNumber)
                let newAcc = Account(nickname: "", phone: phoneNumber)
                
                if let navigationController = self?.navigationController {
                    navigationController.pushViewController(OTPViewController(account: newAcc), animated: true)
                }
            } else {
                self?.showErrorMessage("Phone number not found. Please register first.")
            }
        }
    }
    
    private func navigateToHome() {
        let homeVC = TabBarController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func showErrorMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .red
    }
}
