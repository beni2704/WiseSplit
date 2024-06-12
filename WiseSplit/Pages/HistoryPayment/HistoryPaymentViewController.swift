//
//  HistoryPaymentViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 23/04/24.
//

import Foundation
import UIKit

class HistoryPaymentViewController: UIViewController {
    
    var rectangleBorder = UIView()
    var spendingTitle = UILabel()
    var spendingTotal = UILabel()
    var categoryFilter = UISegmentedControl(items: ["Spending", "Bill Owe", "Bill Received", "Income"])
    
    var tableView: UITableView!
    var historyPaymentVM: HistoryPaymentViewModel!
    var transactions: [TransactionUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyPaymentVM = HistoryPaymentViewModel()
        setupUI()
        fetchSpendingTransaction()
    }
    
    private func setupUI() {
        title = "Transaction History"
        
        rectangleBorder.translatesAutoresizingMaskIntoConstraints = false
        rectangleBorder.layer.cornerRadius = 10
        rectangleBorder.backgroundColor = .lightGray
        view.addSubview(rectangleBorder)
        
        spendingTitle.text = "Total Spending"
        spendingTitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        spendingTitle.translatesAutoresizingMaskIntoConstraints = false
        rectangleBorder.addSubview(spendingTitle)
        
        spendingTotal.text = "RP 0"
        spendingTotal.font = UIFont.preferredFont(forTextStyle: .title3)
        spendingTotal.translatesAutoresizingMaskIntoConstraints = false
        rectangleBorder.addSubview(spendingTotal)
        
        categoryFilter.selectedSegmentIndex = 0
        categoryFilter.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        categoryFilter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryFilter)
        
        // Create table view
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            rectangleBorder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            rectangleBorder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            rectangleBorder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            spendingTitle.topAnchor.constraint(equalTo: rectangleBorder.topAnchor, constant: 16),
            spendingTitle.centerXAnchor.constraint(equalTo: rectangleBorder.centerXAnchor),
            
            spendingTotal.topAnchor.constraint(equalTo: spendingTitle.bottomAnchor, constant: 16),
            spendingTotal.centerXAnchor.constraint(equalTo: rectangleBorder.centerXAnchor),
            spendingTotal.bottomAnchor.constraint(equalTo: rectangleBorder.bottomAnchor, constant: -16),
            
            categoryFilter.topAnchor.constraint(equalTo: rectangleBorder.bottomAnchor, constant: 16),
            categoryFilter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryFilter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: categoryFilter.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        self.addLoading(onView: self.view)
        switch sender.selectedSegmentIndex {
        case 0:
            fetchSpendingTransaction()
        case 1:
            fetchBillOweTransactions()
        case 2:
            fetchBillReceivedTransactions()
        case 3:
            fetchIncome()
        default:
            break
        }
        self.removeLoading()
    }
    
    private func fetchSpendingTransaction() {
        historyPaymentVM.fetchTransactionsSpending { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.tableView.reloadData()
                self?.updateTotalSpending()
                self?.spendingTitle.text = "Total Spending"
            case .failure(let error):
                print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchBillOweTransactions() {
        historyPaymentVM.fetchTransactionsBillOwe { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.tableView.reloadData()
                self?.updateTotalSpending()
                self?.spendingTitle.text = "Total Owe"
            case .failure(let error):
                print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchBillReceivedTransactions() {
        historyPaymentVM.fetchTransactionsBillReceived { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.tableView.reloadData()
                self?.updateTotalSpending()
                self?.spendingTitle.text = "Total Received"
            case .failure(let error):
                print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchIncome() {
        historyPaymentVM.fetchTransactionIncome() { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.tableView.reloadData()
                self?.updateTotalSpending()
                self?.spendingTitle.text = "Total Income"
            case .failure(let error):
                print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateTotalSpending() {
        let totalSpending = abs(transactions.reduce(0) { $0 + $1.amount })
        spendingTotal.text = "\(formatToIDR(totalSpending))"
    }
}

extension HistoryPaymentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier, for: indexPath) as! TransactionTableViewCell
        let transaction = transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let transaction = transactions[indexPath.row]
        if transaction.category == "Split Bill Received" || transaction.category == "Split Bill Owe" {
            let resultViewController = ResultViewController(splitBillId: transaction.splitBillId ?? "empty")
            navigationController?.pushViewController(resultViewController, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
