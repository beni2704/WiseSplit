//
//  OTPViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 24/05/24.
//

import Foundation
import UIKit

class OTPViewController: BaseViewController {
    var otpVM: OTPViewModel?
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var otpLabel = UILabel()
    var otpTF = PaddedTextField()
    var messageLabel = UILabel()
    var verifButton = UIButton()
    var resendButton = UIButton()
    var backButton = UIButton()
    var account: Account
    
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
    
    func setAll() {
        titleLabel.text = "Enter your OTP"
        titleLabel.font = .preferredFont(forTextStyle: .extraLargeTitle)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        subTitleLabel.text = "OTP has been sent to \(account.phone)"
        subTitleLabel.font = .preferredFont(forTextStyle: .headline)
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
        resendButton.setTitleColor(Colors.blueCustom, for: .normal)
        resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resendButton)
        
        backButton.setTitle("Wrong phone number?", for: .normal)
        backButton.setTitleColor(.black, for: .normal)
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
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            titleLabel.widthAnchor.constraint(equalToConstant: 275),
            
            subTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleLabel.widthAnchor.constraint(equalToConstant: 275),
            
            otpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpLabel.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 14),
            otpLabel.widthAnchor.constraint(equalToConstant: 250),
            
            otpTF.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            otpTF.topAnchor.constraint(equalTo: otpLabel.bottomAnchor, constant: 7),
            otpTF.widthAnchor.constraint(equalToConstant: 250),
            otpTF.heightAnchor.constraint(equalToConstant: 44),
            
            verifButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            verifButton.topAnchor.constraint(equalTo: otpTF.bottomAnchor, constant: 14),
            verifButton.widthAnchor.constraint(equalToConstant: 250),
            verifButton.heightAnchor.constraint(equalToConstant: 44),
            
            resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resendButton.topAnchor.constraint(equalTo: verifButton.bottomAnchor, constant: 14),
            
            backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backButton.topAnchor.constraint(equalTo: resendButton.bottomAnchor, constant: 14),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 14),
            messageLabel.widthAnchor.constraint(equalToConstant: 250),
        ])
    }
    
    @objc func verifButtonTapped() {
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
    
    @objc func resendButtonTapped() {
        otpVM?.sendVerificationCode(phoneNumber: account.phone)
        messageLabel.textColor = Colors.greenCustom
        messageLabel.text = "OTP has been resent"
    }
    
    @objc func backButtonTapped() {
        if let navigationController = navigationController {
            navigationController.pushViewController(RegisterViewController(), animated: true)
        }
    }
}
