//
//  HistoryViewController.swift
//  WiseSplit
//
//  Created by ichiro on 25/05/24.
//

import UIKit

class HistoryViewController: UIViewController {
    
    var segmentedControl: UISegmentedControl!
    var containerView: UIView!
    var scrollView1: HistoryScrollView!
    var scrollView2: HistoryScrollView!
    var scrollView3: HistoryScrollView!
    let totalSpendingView = TotalSpending(frame: CGRect(x: 50, y: 100, width: 200, height: 100))
    
    var exampleExpenses1 = [
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date())
    ]
    
    let exampleExpenses2 = [
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date())
    ]
    
    let exampleExpenses3 = [
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "Groceries", expenseDesc: "Weekly groceries", expensePrice: 50.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "car")!, expenseName: "Fuel", expenseDesc: "Car fuel", expensePrice: 40.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "heart")!, expenseName: "Entertainment", expenseDesc: "Movie night", expensePrice: 30.00, expenseDate: Date()),
        Expense(expenseImage: UIImage(systemName: "house")!, expenseName: "Rent", expenseDesc: "Monthly rent", expensePrice: 1000.00, expenseDate: Date())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add TotalSpending view
        totalSpendingView.setText("Total Spending")
        view.addSubview(totalSpendingView)
        
        // Add segmented control
        segmentedControl = UISegmentedControl(items: ["Spending", "Bill Owe", "Bill Received"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)
        
        // Add container view
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Initialize scroll views
        scrollView1 = HistoryScrollView()
        scrollView2 = HistoryScrollView()
        scrollView3 = HistoryScrollView()
        
        setupScrollView(scrollView1)
        setupScrollView(scrollView2)
        setupScrollView(scrollView3)
        
        // Set up constraints
        setupConstraints()
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Expense", for: .normal)
        addButton.addTarget(self, action: #selector(addExpenseButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(addButton)
        
        // Set up constraints for the add button
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 60),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Update content initially
        updateContentForSelectedSegment()
    }
    
    func setupScrollView(_ scrollView: HistoryScrollView) {
        scrollView.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(scrollView)
        containerView.addSubview(scrollView.view)
        scrollView.didMove(toParent: self)
    }
    
    func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            totalSpendingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            totalSpendingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            totalSpendingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            segmentedControl.topAnchor.constraint(equalTo: totalSpendingView.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView1.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            scrollView1.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView1.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView1.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            scrollView2.view.topAnchor.constraint(equalTo: scrollView1.view.bottomAnchor, constant: 20),
            scrollView2.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView2.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView2.view.heightAnchor.constraint(equalTo: scrollView1.view.heightAnchor),
            
            scrollView3.view.topAnchor.constraint(equalTo: scrollView2.view.bottomAnchor, constant: 20),
            scrollView3.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            scrollView3.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            scrollView3.view.heightAnchor.constraint(equalTo: scrollView1.view.heightAnchor)
        ])
    }
    
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateContentForSelectedSegment()
    }
    
    private func updateContentForSelectedSegment() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            
            scrollView1.updateContent(with: exampleExpenses1)
            scrollView2.updateContent(with: exampleExpenses1)
            scrollView3.updateContent(with: exampleExpenses1)
            
        case 1:
            
            scrollView1.updateContent(with: exampleExpenses2)
            scrollView2.updateContent(with: exampleExpenses2)
            scrollView3.updateContent(with: exampleExpenses2)
            
        case 2:
            
            scrollView1.updateContent(with: exampleExpenses3)
            scrollView2.updateContent(with: exampleExpenses3)
            scrollView3.updateContent(with: exampleExpenses3)
            
        default:
            break
        }
    }
    
    @objc func addExpenseButtonTapped(_ sender: UIButton) {
        // Create a new expense and add it to exampleExpenses1
        let newExpense = Expense(expenseImage: UIImage(systemName: "star")!, expenseName: "New Expense", expenseDesc: "Description", expensePrice: 20.00, expenseDate: Date())
        exampleExpenses1.append(newExpense)
        
        // Update scrollView1 with the new expense
        scrollView1.updateContent(with: exampleExpenses1)
    }
}
