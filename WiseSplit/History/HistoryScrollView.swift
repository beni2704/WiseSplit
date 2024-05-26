//
//  HistoryScrollView.swift
//  WiseSplit
//
//  Created by ichiro on 25/05/24.
//

import UIKit

class HistoryScrollView: UIViewController {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var viewModels: [ExpenseViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupViewModels()
    }
    
    private func setupUI() {
        // Set up the scroll view
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(scrollView)
        
        // Set up the stack view
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(stackView)
        
        // Set up stack view constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViewModels() {
        // Example expenses are empty initially
        displayExpenseItems()
    }
    
    private func displayExpenseItems() {
        for viewModel in viewModels {
            let itemView = createExpenseView(for: viewModel)
            stackView.addArrangedSubview(itemView)
        }
    }
    
    private func createExpenseView(for viewModel: ExpenseViewModel) -> UIView {
        let itemView = UIView()
        itemView.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView(image: viewModel.expenseImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = viewModel.expenseName
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let descLabel = UILabel()
        descLabel.text = viewModel.expenseDesc
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let priceLabel = UILabel()
        priceLabel.text = "\(viewModel.expensePrice)"
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let dateLabel = UILabel()
        dateLabel.text = "\(viewModel.expenseDate)"
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itemView.addSubview(imageView)
        itemView.addSubview(nameLabel)
        itemView.addSubview(descLabel)
        itemView.addSubview(priceLabel)
        itemView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: itemView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            nameLabel.topAnchor.constraint(equalTo: itemView.topAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -10),
            
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 5),
            
            dateLabel.leadingAnchor.constraint(equalTo: priceLabel.trailingAnchor, constant: 10),
            dateLabel.topAnchor.constraint(equalTo: priceLabel.topAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: itemView.trailingAnchor, constant: -10),
            
            itemView.bottomAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10)
        ])
        
        return itemView
    }
    
    func updateContent(with expenses: [Expense]) {
        // Clear existing views
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Update viewModels
        viewModels.removeAll()
        for expense in expenses {
            let viewModel = ExpenseViewModel(expense: expense)
            viewModels.append(viewModel)
        }
        
        // Re-display items
        displayExpenseItems()
    }
}
