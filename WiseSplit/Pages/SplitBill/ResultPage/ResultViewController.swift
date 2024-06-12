//
//  ResultBillViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit

class ResultViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AddPaymentInfoDelegate  {
    var resultVM: ResultViewModel?
    
    var splitBillDetail: SplitBill?
    var splitBillDetailId: String?
    
    var isComplete: Bool?
    
    var titleLabel = UILabel()
    var firstText = UILabel()
    var secondText = UILabel()
    var paymentInfo = UILabel()
    var paymentDetail = UILabel()
    var paymentNumber = UILabel()
    var backgroundView = UIView()
    var scrollView = UIScrollView()
    
    var selectedImage: UIImage?
    
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
        fetchSplitBillProcess()
    }
    
    private func fetchSplitBillProcess() {
        fetchSplitBillDetail(splitBillId: splitBillDetailId ?? "empty") { [weak self] in
            self?.setupUI()
            self?.bindViewModel()
            
            if self?.isComplete ?? false {
                self?.setupCustomBackButton()
            }
        }
    }
    
    
    func didSavePaymentInfo() {
        fetchSplitBillProcess()
    }
    
    private func fetchSplitBillDetail(splitBillId: String, completion: @escaping () -> Void) {
        resultVM?.fetchSplitBillDetail(splitBillId: splitBillId) { [weak self] result in
            switch result {
            case .success(let newSplitBill):
                self?.splitBillDetail = newSplitBill ?? SplitBill(title: "", date: Date(), total: 0, imageUrl: "", personTotals: [], ownerId: "")
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    private func setupCustomBackButton() {
        let backButton = UIBarButtonItem(title: "Complete", style: .plain, target: self, action: #selector(backToHome))
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backToHome() {
        navigationController?.popToRootViewController(animated: true)
        let homeVC = TabBarController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func setupUI() {
        setupLabels()
        setupBackgroundView()
        setupScrollView()
        setupButtons()
        setupPaymentInformation()
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
        backgroundView.backgroundColor = Colors.backgroundChartCustom
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
        scrollView.backgroundColor = Colors.backgroundChartCustom
        scrollView.layer.cornerRadius = 10
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        backgroundView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -287),
        ])
    }
    
    private func setupPaymentInformation() {
        if splitBillDetail?.paymentInfo == nil {
            return
        }
        
        paymentInfo.text = "Payment Information"
        paymentInfo.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentInfo)
        
        paymentDetail.text = "\(splitBillDetail?.paymentInfo?.paymentMethod ?? "empty") - \(splitBillDetail?.paymentInfo?.accountName ?? "empty")"
        paymentDetail.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentDetail)
        
        paymentNumber.text = splitBillDetail?.paymentInfo?.accountNumber ?? "empty"
        paymentNumber.font = UIFont.preferredFont(forTextStyle: .title3)
        paymentNumber.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentNumber)
        
        NSLayoutConstraint.activate([
            paymentInfo.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            paymentInfo.bottomAnchor.constraint(equalTo: paymentDetail.topAnchor, constant: -16),
            paymentInfo.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            paymentInfo.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            paymentDetail.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            paymentDetail.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            
            paymentNumber.topAnchor.constraint(equalTo: paymentDetail.bottomAnchor, constant: 4),
            paymentNumber.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            paymentNumber.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
        ])
    }
    
    private func setupButtons() {
        guard let splitBillDetail = splitBillDetail else {
            return
        }
        
        if resultVM?.isOwner(splitBillOwnerId: splitBillDetail.ownerId) ?? true {
            let addPaymentButton = UIButton(type: .system)
            addPaymentButton.setTitle("Add/Edit Your Payment Information", for: .normal)
            addPaymentButton.setTitleColor(.white, for: .normal)
            addPaymentButton.addTarget(self, action: #selector(addPaymentButtonTapped), for: .touchUpInside)
            addPaymentButton.backgroundColor = .gray
            addPaymentButton.translatesAutoresizingMaskIntoConstraints = false
            addPaymentButton.layer.cornerRadius = 12
            backgroundView.addSubview(addPaymentButton)
            
            let shareLink = UIButton(type: .system)
            shareLink.setTitle("Share Bill", for: .normal)
            shareLink.setTitleColor(.white, for: .normal)
            shareLink.addTarget(self, action: #selector(shareLinkButtonTapped), for: .touchUpInside)
            shareLink.backgroundColor = Colors.greenCustom
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
            resultVM?.checkPaid(splitBillId: splitBillDetailId ?? "empty", completion: { res in
                if res {
                    let confirmPayment = UIButton(type: .system)
                    confirmPayment.setTitle("Payment", for: .normal)
                    confirmPayment.setTitleColor(.white, for: .normal)
                    confirmPayment.addTarget(self, action: #selector(self.proceedPayment), for: .touchUpInside)
                    confirmPayment.backgroundColor = Colors.greenCustom
                    confirmPayment.translatesAutoresizingMaskIntoConstraints = false
                    confirmPayment.layer.cornerRadius = 12
                    self.backgroundView.addSubview(confirmPayment)
                    
                    NSLayoutConstraint.activate([
                        confirmPayment.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -16),
                        confirmPayment.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 16),
                        confirmPayment.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -16),
                        confirmPayment.heightAnchor.constraint(equalToConstant: 39),
                    ])
                }
                else {
                    let confirmPayment = UIButton(type: .system)
                    confirmPayment.setTitle("Already Paid", for: .normal)
                    confirmPayment.setTitleColor(.white, for: .normal)
                    confirmPayment.isEnabled = false
                    confirmPayment.backgroundColor = .gray
                    confirmPayment.translatesAutoresizingMaskIntoConstraints = false
                    confirmPayment.layer.cornerRadius = 12
                    self.backgroundView.addSubview(confirmPayment)
                    
                    NSLayoutConstraint.activate([
                        confirmPayment.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -16),
                        confirmPayment.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: 16),
                        confirmPayment.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -16),
                        confirmPayment.heightAnchor.constraint(equalToConstant: 39),
                    ])
                }
            })
            
        }
    }
    
    private func bindViewModel() {
        setupBackgroundView(backgroundView)
        setupScrollView(scrollView, in: backgroundView)
        displayUsers()
        setupPaymentInformation()
    }
    
    func setupBackgroundView(_ backgroundView: UIView) {
        backgroundView.backgroundColor = Colors.backgroundChartCustom
        backgroundView.layer.cornerRadius = 10
    }
    
    func setupScrollView(_ scrollView: UIScrollView, in backgroundView: UIView) {
        scrollView.backgroundColor = Colors.backgroundChartCustom
        scrollView.layer.cornerRadius = 10
        scrollView.showsVerticalScrollIndicator = true
        backgroundView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -287)
        ])
    }
    
    private func displayUsers() {
        var lastView: UIView? = nil
        
        guard let personTotals = splitBillDetail?.personTotals else {
            return
        }
        
        var index = 0
        for person in personTotals {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = Colors.backgroundChartCustom
            scrollView.addSubview(containerView)
            
            let nameLabel = UILabel()
            nameLabel.text = "\(person.personName) - \(formatToIDR(person.totalAmount))"
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
            statusButton.backgroundColor = person.imagePaidUrl == "Owner" ? .black : person.personPhoneNumber == "Not Registered" ? .gray : person.isPaid ? Colors.greenCustom : Colors.redCustom
            statusButton.setTitleColor(.white, for: .normal)
            statusButton.isEnabled = person.isPaid ? true : false
            statusButton.translatesAutoresizingMaskIntoConstraints = false
            statusButton.layer.cornerRadius = 12
            statusButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 8, right: 4)
            containerView.addSubview(statusButton)
            
            statusButton.tag = index
            if person.personPhoneNumber != "Not Registered" {
                statusButton.addTarget(self, action: #selector(openPaymentInfoPage), for: .touchUpInside)
            }
            index += 1
            
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
                
                print("person.items: -> \(person.items)")
                
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
    
    func setupDoneImageButton(imagePickerController: UIImagePickerController) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        
        imagePickerController.view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.bottomAnchor.constraint(equalTo: imagePickerController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: imagePickerController.view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: imagePickerController.view.trailingAnchor).isActive = true
    }
    
    // MARK: - Button Actions
    
    @objc private func addPaymentButtonTapped() {
        let addPaymentVC = AddPaymentInfoViewController(splitBillId: self.splitBillDetailId ?? "empty")
        addPaymentVC.delegate = self
        showSheet(vc: addPaymentVC, presentingVC: self)
    }
    
    @objc private func shareLinkButtonTapped() {
        let predefinedSentence = "Your split bill have been created"
        let activityViewController = UIActivityViewController(activityItems: [predefinedSentence], applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            .postToFacebook,
            .postToTwitter,
            .postToWeibo,
            .message,
            .mail,
            .print,
            .assignToContact,
            .saveToCameraRoll,
            .addToReadingList,
            .postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            .airDrop,
            .openInIBooks
        ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func openPaymentInfoPage(sender: UIButton) {
        let imageVC = ImageViewController()
        imageVC.capturedImage = splitBillDetail?.image
        imageVC.capturedImage = splitBillDetail?.personTotals[sender.tag].imagePaid
        navigationController?.pushViewController(imageVC, animated: true)
    }
    
    @objc private func proceedPayment() {
        guard let splitBillDetail = splitBillDetail else {
            return
        }
        
        resultVM?.checkBudgetToPay(splitBill: splitBillDetail, completion: { result in
            switch result {
            case .success(let valid):
                if !valid {
                    presentingAlert(title: "Your Budget not enough!", message: "Please add budget until sufficient amount", view: self)
                    self.removeLoading()
                    return
                }else {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.sourceType = .photoLibrary
                    
                    self.setupDoneImageButton(imagePickerController: imagePickerController)
                    self.present(imagePickerController, animated: true, completion: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
        
    }
    
    @objc private func doneButtonTapped() {
        guard let picker = presentedViewController as? UIImagePickerController else { return }
        
        if let selectedImage = self.selectedImage {
            let alertController = UIAlertController(title: "Confirm", message: "Do you want to use this image?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                picker.dismiss(animated: true, completion: {
                    self.addLoading(onView: self.view)
                    self.resultVM?.updatePaymentStatus(image: selectedImage, splitBillDetailId: self.splitBillDetailId ?? "nil", completion: { res in
                        switch res {
                        case .success():
                            let successAlert = UIAlertController(title: "Success", message: "Image selected successfully!", preferredStyle: .alert)
                            successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(successAlert, animated: true, completion: nil)
                            self.fetchSplitBillProcess()
                            self.removeLoading()
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    })
                    
                })
            }))
            picker.present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
