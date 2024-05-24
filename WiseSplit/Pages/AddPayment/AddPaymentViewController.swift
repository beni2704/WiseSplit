//
//  AddPaymentViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import Foundation
import UIKit

class AddPaymentViewController: BaseViewController {
    var addPaymentVM: AddPaymentViewModel?
    var titleLabel = UILabel()
    var titleBudgetTF = UILabel()
    var budgetTF = PaddedTextField()
    var titleCategoryTF = UILabel()
    var categoryPicker = UIPickerView()
    var categories = ["Transportation", "Food & Beverage", "Entertainment", "Health Care"]
    var categoryTF = PaddedTextField()
    var titleDateTF = UILabel()
    var datePicker = UIDatePicker()
    var dateTF = PaddedTextField()
    var errorLabel = UILabel()
    var addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPaymentVM = AddPaymentViewModel()
        setupViews()
        setupCategoryPicker()
        setupDatePicker()
    }
    
    private func setupViews() {
        titleLabel.text = "Add Your Transaction"
        titleLabel.font = .preferredFont(forTextStyle: .title1)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleBudgetTF.text = "Amount"
        titleBudgetTF.font = .preferredFont(forTextStyle: .callout)
        titleBudgetTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleBudgetTF)
        
        budgetTF.placeholder = "IDR"
        budgetTF.borderStyle = .none
        budgetTF.backgroundColor = UIColor.grayBgFormCustom
        budgetTF.layer.cornerRadius = 14
        budgetTF.keyboardType = .numberPad
        budgetTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(budgetTF)
        
        titleCategoryTF.text = "Category"
        titleCategoryTF.font = .preferredFont(forTextStyle: .callout)
        titleCategoryTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleCategoryTF)
        
        categoryTF.placeholder = "Select Category"
        categoryTF.borderStyle = .none
        categoryTF.backgroundColor = UIColor.grayBgFormCustom
        categoryTF.layer.cornerRadius = 14
        categoryTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryTF)
        
        titleDateTF.text = "Date"
        titleDateTF.font = .preferredFont(forTextStyle: .callout)
        titleDateTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleDateTF)
        
        dateTF.placeholder = "Select Date"
        dateTF.borderStyle = .none
        dateTF.backgroundColor = UIColor.grayBgFormCustom
        dateTF.layer.cornerRadius = 14
        dateTF.keyboardType = .numberPad
        dateTF.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dateTF)
        
        errorLabel.text = ""
        errorLabel.textColor = .redCustom
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(errorLabel)
        
        addButton.setTitle("Add Payment", for: .normal)
        addButton.addTarget(self, action: #selector(addPayment), for: .touchUpInside)
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 5
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleBudgetTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            titleBudgetTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            budgetTF.topAnchor.constraint(equalTo: titleBudgetTF.bottomAnchor, constant: 4),
            budgetTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            budgetTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            budgetTF.heightAnchor.constraint(equalToConstant: 48),
            
            titleCategoryTF.topAnchor.constraint(equalTo: budgetTF.bottomAnchor, constant: 16),
            titleCategoryTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            categoryTF.topAnchor.constraint(equalTo: titleCategoryTF.bottomAnchor, constant: 4),
            categoryTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryTF.heightAnchor.constraint(equalToConstant: 48),
            
            titleDateTF.topAnchor.constraint(equalTo: categoryTF.bottomAnchor, constant: 16),
            titleDateTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            dateTF.topAnchor.constraint(equalTo: titleDateTF.bottomAnchor, constant: 4),
            dateTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateTF.heightAnchor.constraint(equalToConstant: 48),
            
            errorLabel.topAnchor.constraint(equalTo: dateTF.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            addButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupCategoryPicker() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryTF.inputView = categoryPicker
    }
    
    @objc private func addPayment() {
        guard let budgetText = budgetTF.text, let amount = Int(budgetText) else {
            return
        }
        
        guard let selectedCategory = categoryTF.text, !selectedCategory.isEmpty else {
            return
        }
        
        let date = datePicker.date
        
        addPaymentVM?.addPayment(amount: amount, category: selectedCategory, date: date) { error in
            if let error = error {
                print("Error adding payment: \(error.localizedDescription)")
                switch error {
                case AddPaymentError.emptyField:
                    self.errorLabel.text = "All fields must be filled"
                case AddPaymentError.invalidAmount:
                    self.errorLabel.text = "Amount must be above 0"
                case AddPaymentError.insufficientAmount:
                    self.errorLabel.text = "Budget is not enough"
                default:
                    self.errorLabel.text = "An error occurred"
                }
            } else {
                let alertController = UIAlertController(title: "Payment Added", message: "Your payment of \(amount) Rupiah has been added.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.budgetTF.text = ""
                self.categoryTF.text = ""
                self.dateTF.text = ""
                self.errorLabel.text = ""
            }
        }
    }
}
