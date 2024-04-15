//
//  AddBudgetViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import UIKit

class AddBudgetViewController: BaseViewController {
    var titleLabel = UILabel()
    var titleBudgetTF = UILabel()
    var budgetTF = PaddedTextField()
    var addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        titleLabel.text = "Add Your Budget"
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
        
        addButton.setTitle("Add Your Budget", for: .normal)
        addButton.addTarget(self, action: #selector(addBudget), for: .touchUpInside)
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
            
            addButton.topAnchor.constraint(equalTo: budgetTF.bottomAnchor, constant: 20),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    @objc private func addBudget() {
        guard let budgetText = budgetTF.text, let amount = Int(budgetText) else {
            // Handle invalid input
            return
        }
        
        // Do something with the budget amount, for example, save it to a database
        
        // Clear the text field after adding the budget
        budgetTF.text = ""
        
        // Show a confirmation alert or perform any other necessary action
        let alertController = UIAlertController(title: "Budget Added", message: "Your budget of \(amount) Rupiah has been added.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
