//
//  HistoryPaymentViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 23/04/24.
//

import Foundation
import UIKit

class HistoryPaymentViewController: UIViewController {
    
    var tableView: UITableView!
    var historyPaymentVM: HistoryPaymentViewModel!
    var transactions: [TransactionUser] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        historyPaymentVM = HistoryPaymentViewModel()
        setupUI()
        fetchTransactions()
    }
    
    private func setupUI() {
        title = "Transaction History"
        
        // Create table view
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func fetchTransactions() {
        historyPaymentVM.fetchTransactions { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error fetching transactions: \(error.localizedDescription)")
            }
        }
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
}
