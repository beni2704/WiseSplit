//
//  AddPaymentInfo.swift
//  Live Detector
//
//  Created by ichiro on 26/05/24.
//

import UIKit

class AddPaymentInfoViewController: UIViewController {
    var addPaymentVM: AddPaymentInfoViewModel?
    var firstText = UILabel()
    var secondText = UILabel()
    
    var paymentMethodLabel = UILabel()
    var paymentMethodTF = UITextField()
    var accountNameLabel = UILabel()
    var accountNameTF = UITextField()
    var accountNumberLabel = UILabel()
    var accountNumberTF = UITextField()
    
    var splitBillId: String
    
    weak var delegate: AddPaymentInfoDelegate?
    
    init(splitBillId: String) {
        self.splitBillId = splitBillId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPaymentVM = AddPaymentInfoViewModel()
        view.backgroundColor = .white
        setup()
    }
    
    private func setup() {
        labelSetup()
        formSetup()
        buttonSetup()
        setupCloseButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func labelSetup() {
        firstText.text = "Add Payment Info"
        firstText.font = UIFont.boldSystemFont(ofSize: 24)
        //firstText.font = UIFont.preferredFont(forTextStyle: .title1)
        
        firstText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstText)
        
        secondText.text = "Add your payment information so your friend can repay you later."
        //secondText.font = UIFont.boldSystemFont(ofSize: 16)
        secondText.font = UIFont.preferredFont(forTextStyle: .caption1)
        secondText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondText)
        
        NSLayoutConstraint.activate([
            
            firstText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            firstText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 0),
            secondText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            
        ])
        
    }
    
    private func formSetup() {
        setupForm(label: paymentMethodLabel, textField: paymentMethodTF, text: "Payment Method", placeholder: "Google Pay")
        setupForm(label: accountNameLabel, textField: accountNameTF, text: "Account Name", placeholder: "John Doe")
        setupForm(label: accountNumberLabel, textField: accountNumberTF, text: "Account Number", placeholder: "1234 5678 9012")
        
        NSLayoutConstraint.activate([
            paymentMethodLabel.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 16),
            paymentMethodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            paymentMethodTF.topAnchor.constraint(equalTo: paymentMethodLabel.bottomAnchor, constant: 8),
            paymentMethodTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            paymentMethodTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            paymentMethodTF.heightAnchor.constraint(equalToConstant: 40),
            
            accountNameLabel.topAnchor.constraint(equalTo: paymentMethodTF.bottomAnchor, constant: 16),
            accountNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            accountNameTF.topAnchor.constraint(equalTo: accountNameLabel.bottomAnchor, constant: 8),
            accountNameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountNameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountNameTF.heightAnchor.constraint(equalToConstant: 40),
            
            accountNumberLabel.topAnchor.constraint(equalTo: accountNameTF.bottomAnchor, constant: 16),
            accountNumberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            accountNumberTF.topAnchor.constraint(equalTo: accountNumberLabel.bottomAnchor, constant: 8),
            accountNumberTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            accountNumberTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            accountNumberTF.heightAnchor.constraint(equalToConstant: 40),
            
        ])
    }
    
    private func setupForm(label: UILabel, textField: UITextField, text: String, placeholder: String) {
        label.text = text
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
    }
    
    private func buttonSetup() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.backgroundColor = AppTheme.green
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 33),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupCloseButton() {
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func saveButtonTapped() {
        
        guard let paymentMethod = paymentMethodTF.text, let accountName = accountNameTF.text, let accountNumber = accountNumberTF.text else {
            return
        }
        
        if ((addPaymentVM?.checkEmpty(paymentMethod: paymentMethod, accountName: accountName, accountNumber: accountNumber)) != nil) {
            presentingAlert(title: "Empty Field", message: "Please enter all payment fields", view: self)
            return
        }
        
        let newPayment = PaymentInfo(paymentMethod: paymentMethod, accountName: accountName, accountNumber: accountNumber)
        addPaymentVM?.savePaymentInfo(splitBillId: self.splitBillId, paymentInfo: newPayment) { res in
            switch res {
            case.success():
                self.delegate?.didSavePaymentInfo()
                self.dismiss(animated: true, completion: nil)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
