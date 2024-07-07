//
//  OTPViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 24/05/24.
//

import Foundation
import UIKit

class OTPViewController: BaseViewController {
    private var otpVM: OTPViewModel?
    private var logoApp = UIImageView()
    private var titleLabel = UILabel()
    private var subTitleLabel = UILabel()
    private var otpLabel = UILabel()
    private var otpTF = PaddedTextField()
    private var messageLabel = UILabel()
    private var verifButton = UIButton()
    private var resendButton = UIButton()
    private var backButton = UIButton()
    private var account: Account
    
    init(account: Account) {
        self.account = account
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        otpVM = OTPViewModel()
        setAll()
    }
    
    private func setAll() {
        titleLabel.text = "Check Your Inbox"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "OTP has been sent to \(account.phone). Input the OTP to verify your account."
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textColor = .gray
        subTitleLabel.textAlignment = .center
        subTitleLabel.font = .preferredFont(forTextStyle: .body)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subTitleLabel)
        
        otpLabel.text = "OTP (6 code)"
        otpLabel.translatesAutoresizingMaskIntoConstraints = false
        otpLabel.font = .preferredFont(forTextStyle: .callout)
        view.addSubview(otpLabel)
        
        otpTF.placeholder = "123456"
        otpTF.borderStyle = .none
        otpTF.backgroundColor = Colors.backgroundFormCustom
        otpTF.layer.cornerRadius = 8
        otpTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(otpTF)
        
        verifButton.setTitle("Verify", for: .normal)
        verifButton.backgroundColor = .systemBlue
        verifButton.layer.cornerRadius = 12
        verifButton.addTarget(self, action: #selector(verifButtonTapped), for: .touchUpInside)
        verifButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verifButton)
        
        resendButton.setTitle("Resend OTP", for: .normal)
        resendButton.setTitleColor(Colors.base, for: .normal)
        resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resendButton)
        
        backButton.setTitle("Wrong phone number?", for: .normal)
        backButton.setTitleColor(Colors.base, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backButton)
        
        messageLabel.text = ""
        messageLabel.textColor = Colors.redCustom
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            
            subTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            
            otpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            otpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            otpLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 24),
            
            otpTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            otpTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            otpTF.topAnchor.constraint(equalTo: otpLabel.bottomAnchor, constant: 4),
            otpTF.heightAnchor.constraint(equalToConstant: 44),
            
            verifButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            verifButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            verifButton.topAnchor.constraint(equalTo: otpTF.bottomAnchor, constant: 24),
            verifButton.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: verifButton.bottomAnchor, constant: 16),
            
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendButton.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 16),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: resendButton.bottomAnchor, constant: 16),
            messageLabel.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    @objc private func verifButtonTapped() {
        guard let otpCode = otpTF.text else { return }
        
        self.addLoading(onView: self.view)
        
        otpVM?.signInWithVerificationCode(verificationCode: otpCode, withAccount: account) { [weak self] result in
            switch result {
            case .success(_):
                if let navigationController = self?.navigationController {
                    navigationController.pushViewController(TabBarController(), animated: true)
                }
            case .failure(_):
                self?.messageLabel.textColor = Colors.redCustom
                self?.messageLabel.text = "Wrong OTP"
                self?.removeLoading()
            }
        }
    }
    
    @objc private func resendButtonTapped() {
        otpVM?.sendVerificationCode(phoneNumber: account.phone)
        messageLabel.textColor = Colors.greenCustom
        messageLabel.text = "OTP has been resent"
    }
    
    @objc private func backButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(RegisterViewController(), animated: true)
        }
    }
}
