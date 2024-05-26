//
//  LoginViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 22/03/24.
//
import UIKit

class LoginViewController: BaseViewController {
    var loginVM: LoginViewModel?
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var phoneLabel = UILabel()
    var phoneTF = PaddedTextField()
    var messageLabel = UILabel()
    var loginButton = UIButton()
    var registerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        loginVM = LoginViewModel()
        setAll()
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
        
        phoneLabel.text = "Phone (e.g +6281389971674)"
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.font = .preferredFont(forTextStyle: .callout)
        view.addSubview(phoneLabel)
        
        phoneTF.placeholder = "Phone Number"
        phoneTF.borderStyle = .none
        phoneTF.backgroundColor = .grayBgFormCustom
        phoneTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(phoneTF)
        
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
            
            phoneLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14),
            phoneLabel.widthAnchor.constraint(equalToConstant: 250),
            phoneLabel.heightAnchor.constraint(equalToConstant: 44),
            
            phoneTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            phoneTF.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 7),
            phoneTF.widthAnchor.constraint(equalToConstant: 250),
            phoneTF.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 14),
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
    
    func navigateToHome() {
        let homeVC = TabBarController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    func showErrorMessage(_ message: String) {
        messageLabel.text = message
        messageLabel.textColor = .red
    }
}
