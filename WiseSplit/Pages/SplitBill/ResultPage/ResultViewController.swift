//
//  ResultBillViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel: ResultViewModel!
    
    private var titleLabel = UILabel()
    private var firstText = UILabel()
    private var secondText = UILabel()
    private var backgroundView = UIView()
    private var scrollView = UIScrollView()
    
    // MARK: - Initialization
    
    init(viewModel: ResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupLabels()
        setupBackgroundView()
        setupScrollView()
        setupButtons()
    }
    
    private func setupLabels() {
        titleLabel.text = "Total Amount"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        firstText.text = viewModel.billName
        firstText.font = UIFont.boldSystemFont(ofSize: 24)
        firstText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstText)
        
        secondText.text = "Bill Date"
        secondText.font = UIFont.preferredFont(forTextStyle: .caption1)
        secondText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondText)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            firstText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            firstText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 8),
            secondText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            backgroundView.widthAnchor.constraint(equalToConstant: 370),
            backgroundView.heightAnchor.constraint(equalToConstant: 524)
        ])
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .lightGray
        scrollView.layer.cornerRadius = 10
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        backgroundView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -287)
        ])
    }
    
    private func setupButtons() {
        let addPaymentButton = UIButton(type: .system)
        addPaymentButton.setTitle("Add/Edit Your Payment Information", for: .normal)
        addPaymentButton.setTitleColor(.white, for: .normal)
        addPaymentButton.addTarget(self, action: #selector(addPaymentButtonTapped), for: .touchUpInside)
        addPaymentButton.backgroundColor = .gray // Update with your AppTheme
        addPaymentButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(addPaymentButton)
        
        let shareLink = UIButton(type: .system)
        shareLink.setTitle("Share Bill", for: .normal)
        shareLink.setTitleColor(.white, for: .normal)
        shareLink.addTarget(self, action: #selector(shareLinkButtonTapped), for: .touchUpInside)
        shareLink.backgroundColor = .green // Update with your AppTheme
        shareLink.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(shareLink)
        
        NSLayoutConstraint.activate([
            shareLink.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            shareLink.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            shareLink.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            shareLink.heightAnchor.constraint(equalToConstant: 39),
            
            addPaymentButton.bottomAnchor.constraint(equalTo: shareLink.topAnchor, constant: -16),
            addPaymentButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            addPaymentButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            addPaymentButton.heightAnchor.constraint(equalToConstant: 39)
        ])
    }
    
    private func bindViewModel() {
        titleLabel.text = viewModel.titleLabelText
        firstText.text = viewModel.firstLabelText
        secondText.text = viewModel.secondLabelText
        viewModel.setupBackgroundView(backgroundView)
        viewModel.setupScrollView(scrollView, in: backgroundView)

        displayUsers()
    }
    
    private func displayUsers() {
        var lastView: UIView? = nil
        
        for user in viewModel.displayedUsers {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .lightGray
            scrollView.addSubview(containerView)
            
            let nameLabel = UILabel()
            nameLabel.text = viewModel.userNameText(for: user)
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(nameLabel)
            
            let phoneNumberLabel = UILabel()
            phoneNumberLabel.text = viewModel.userPhoneNumberText(for: user)
            phoneNumberLabel.font = UIFont.boldSystemFont(ofSize: 9)
            phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(phoneNumberLabel)
            
            let statusButton = UIButton(type: .system)
            statusButton.setTitle(viewModel.userStatusButtonText(for: user), for: .normal)
            statusButton.backgroundColor = viewModel.userStatusButtonColor(for: user)
            statusButton.setTitleColor(.white, for: .normal)
            statusButton.isEnabled = viewModel.userStatusButtonEnabled(for: user)
            statusButton.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(statusButton)
            
            if user.paidStatus {
                statusButton.addTarget(self, action: #selector(openPaymentPage), for: .touchUpInside)
            }
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? scrollView.topAnchor, constant: 16),
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                
                nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                
                phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                phoneNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                phoneNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                
                statusButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor, constant: 4),
                statusButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
            ])
            
            lastView = containerView
            
            let divider = UIView()
            divider.backgroundColor = .gray
            divider.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(divider)
            
            NSLayoutConstraint.activate([
                divider.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
                divider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                divider.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                divider.heightAnchor.constraint(equalToConstant: 1),
            ])
            
            lastView = divider
            
            for item in user.assignedItems {
                let itemLabel = UILabel()
                itemLabel.text = item
                itemLabel.font = UIFont.systemFont(ofSize: 16)
                itemLabel.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(itemLabel)
                
                NSLayoutConstraint.activate([
                    itemLabel.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 8),
                    itemLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32),
                    itemLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
                ])
                
                lastView = itemLabel
            }
        }
        
        if let lastView = lastView {
            lastView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        }

        scrollView.layoutIfNeeded()
    }
    
    // MARK: - Button Actions
    
    @objc private func addPaymentButtonTapped() {
        let addPaymentInfoVC = AddPaymentInfo()
        let navigationController = UINavigationController(rootViewController: addPaymentInfoVC)
        navigationController.modalPresentationStyle = .pageSheet
        
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc private func shareLinkButtonTapped() {
        // Share link logic
    }
    
    @objc private func openPaymentPage() {
        let paymentViewController = PaymentViewController()
        navigationController?.pushViewController(paymentViewController, animated: true)
    }
}
