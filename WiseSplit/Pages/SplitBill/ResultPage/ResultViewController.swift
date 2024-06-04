//
//  ResultBillViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit

class ResultViewController: UIViewController {
    
    var resultVM: ResultViewModel?
    var splitBillDetail: SplitBill?
    var splitBillDetailId: String?
    
    var isComplete: Bool?
    
    var titleLabel = UILabel()
    var firstText = UILabel()
    var secondText = UILabel()
    var paymentInfo = UILabel()
    var paymentDetail = UILabel()
    var backgroundView = UIView()
    var scrollView = UIScrollView()
    
    init(splitBillId: String) {
        self.resultVM = ResultViewModel()
        self.splitBillDetailId = splitBillId
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchSplitBillDetail(splitBillId: splitBillDetailId ?? "empty") { [weak self] in
            self?.setupUI()
            self?.bindViewModel()
            
            if self?.isComplete ?? false {
                self?.setupCustomBackButton()
            }
        }
    }
    
    private func fetchSplitBillDetail(splitBillId: String, completion: @escaping () -> Void) {
        resultVM?.fetchSplitBillDetail(splitBillId: splitBillId) { [weak self] result in
            switch result {
            case .success(let newSplitBill):
                self?.splitBillDetail = newSplitBill ?? SplitBill(title: "", date: Date(), total: 0, imageUrl: "", personTotals: [])
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    private func setupCustomBackButton() {
        let backButton = UIBarButtonItem(title: "Complete", style: .plain, target: self, action: #selector(backToRoot))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupLabels()
        setupBackgroundView()
        setupScrollView()
        setupButtons()
    }
    
    private func setupLabels() {
        guard let splitBillDetail = splitBillDetail else {
            return
        }
        
        titleLabel.text = "Total Amount \(formatToIDR(splitBillDetail.total))"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        firstText.text = splitBillDetail.title
        firstText.font = UIFont.boldSystemFont(ofSize: 24)
        firstText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstText)
        
        secondText.text = formatDateHour(splitBillDetail.date.description)
        secondText.font = UIFont.preferredFont(forTextStyle: .caption1)
        secondText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondText)
        
        paymentInfo.text = "Payment Information"
        paymentInfo.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentInfo)
        
        paymentDetail.text = "bank - nama - no rek"
        paymentDetail.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentDetail)
        
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
        guard let splitBillDetail = splitBillDetail else {
            return
        }
        
        if splitBillDetail.imageUrl == "Owner" {
            let addPaymentButton = UIButton(type: .system)
            addPaymentButton.setTitle("Add/Edit Your Payment Information", for: .normal)
            addPaymentButton.setTitleColor(.white, for: .normal)
            addPaymentButton.addTarget(self, action: #selector(addPaymentButtonTapped), for: .touchUpInside)
            addPaymentButton.backgroundColor = .gray // Update with your AppTheme
            addPaymentButton.translatesAutoresizingMaskIntoConstraints = false
            addPaymentButton.layer.cornerRadius = 12
            backgroundView.addSubview(addPaymentButton)
            
            let shareLink = UIButton(type: .system)
            shareLink.setTitle("Share Bill", for: .normal)
            shareLink.setTitleColor(.white, for: .normal)
            shareLink.addTarget(self, action: #selector(shareLinkButtonTapped), for: .touchUpInside)
            shareLink.backgroundColor = .green // Update with your AppTheme
            shareLink.translatesAutoresizingMaskIntoConstraints = false
            shareLink.layer.cornerRadius = 12
            backgroundView.addSubview(shareLink)
            
            NSLayoutConstraint.activate([
                shareLink.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
                shareLink.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
                shareLink.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                shareLink.heightAnchor.constraint(equalToConstant: 39),
                
                addPaymentButton.bottomAnchor.constraint(equalTo: shareLink.topAnchor, constant: -16),
                addPaymentButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
                addPaymentButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                addPaymentButton.heightAnchor.constraint(equalToConstant: 39),
                
                
            ])
        } else {
            let confirmPayment = UIButton(type: .system)
            confirmPayment.setTitle("Share Bill", for: .normal)
            confirmPayment.setTitleColor(.white, for: .normal)
            confirmPayment.addTarget(self, action: #selector(shareLinkButtonTapped), for: .touchUpInside)
            confirmPayment.backgroundColor = .green
            confirmPayment.translatesAutoresizingMaskIntoConstraints = false
            confirmPayment.layer.cornerRadius = 12
            backgroundView.addSubview(confirmPayment)
            
            NSLayoutConstraint.activate([
                confirmPayment.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
                confirmPayment.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
                confirmPayment.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                confirmPayment.heightAnchor.constraint(equalToConstant: 39),
                
                paymentDetail.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
                paymentDetail.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                paymentDetail.heightAnchor.constraint(equalToConstant: 39),
                
                paymentInfo.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
                paymentInfo.bottomAnchor.constraint(equalTo: paymentDetail.topAnchor, constant: -16),
                paymentInfo.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
                paymentInfo.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                paymentInfo.heightAnchor.constraint(equalToConstant: 39),
            ])
        }
        
        
    }
    
    private func bindViewModel() {
        resultVM?.setupBackgroundView(backgroundView)
        resultVM?.setupScrollView(scrollView, in: backgroundView)

        displayUsers()
    }
    
    private func displayUsers() {
        var lastView: UIView? = nil
        
        guard let personTotals = splitBillDetail?.personTotals else {
            return
        }
        
        for person in personTotals {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .lightGray
            scrollView.addSubview(containerView)
            
            let nameLabel = UILabel()
            nameLabel.text = person.personName
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(nameLabel)
            
            let phoneNumberLabel = UILabel()
            phoneNumberLabel.text = person.personPhoneNumber
            phoneNumberLabel.font = UIFont.boldSystemFont(ofSize: 9)
            phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(phoneNumberLabel)
            
            let statusButton = UIButton(type: .system)
            statusButton.setTitle(person.imagePaidUrl == "Owner" ? "Owner" : person.personPhoneNumber == "Not Registered" ? "Anonym" : person.isPaid ? "Paid" : "Not Paid", for: .normal)
            statusButton.backgroundColor = person.imagePaidUrl == "Owner" ? .black : person.personPhoneNumber == "Not Registered" ? .grayCustom : person.isPaid ? .greenCustom : .redCustom
            statusButton.setTitleColor(.white, for: .normal)
            statusButton.isEnabled = person.isPaid ? true : false
            statusButton.translatesAutoresizingMaskIntoConstraints = false
            statusButton.layer.cornerRadius = 12
            statusButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 4)
            containerView.addSubview(statusButton)
            
            if person.personPhoneNumber != "Not Registered" {
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
                
                statusButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
                statusButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
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
            
            for item in person.items {
                let itemLabel = UILabel()
                itemLabel.text = "\(item.name) x\(item.quantity) = \(formatToIDR(item.price))"
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
        showSheet(vc: AddPaymentInfo(), presentingVC: self)
    }
    
    @objc private func shareLinkButtonTapped() {
        
    }
    
    @objc private func openPaymentPage() {
        let imageVC = ImageViewController()
        imageVC.capturedImage = splitBillDetail?.image
        navigationController?.pushViewController(imageVC, animated: true)
    }
}
