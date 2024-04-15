//
//  HomeViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 02/04/24.
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    var titleLabel = UILabel()
    var notifButton = UIButton()
    var numBudget = UILabel()
    var titleBudget = UILabel()
    var spendingTitle = UILabel()
    var spendingButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHome()
    }
    
    private func setupHome() {
        setupTitle()
    }
    
    private func setupTitle() {
        titleLabel.text = "Hai, \(Auth.auth().currentUser?.email ?? "Guest")"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        notifButton.setImage(UIImage(systemName: "bell.fill"), for: .normal)
        notifButton.tintColor = .yellowCustom
        notifButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(notifButton)
        
        numBudget.text = "Rp 7.000.000"
        numBudget.font = UIFont.preferredFont(forTextStyle: .title2)
        numBudget.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(numBudget)
        
        titleBudget.text = "Remaining budget"
        titleBudget.textColor = UIColor.grayCustom
        titleBudget.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleBudget)
        
        spendingTitle.text = "Spending Report"
        spendingTitle.textColor = UIColor.darkGrayCustom
        spendingTitle.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spendingTitle)

        spendingButton.setTitle("See all", for: .normal)
        spendingButton.setTitleColor(UIColor.blueButtonCustom, for: .normal)
        spendingButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        spendingButton.addTarget(self, action: #selector(seeAllButtonTapped), for: .touchUpInside)
        spendingButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spendingButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            notifButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            notifButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            numBudget.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            numBudget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleBudget.topAnchor.constraint(equalTo: numBudget.bottomAnchor, constant: 4),
            titleBudget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            spendingTitle.topAnchor.constraint(equalTo: titleBudget.bottomAnchor, constant: 16),
            spendingTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            spendingButton.topAnchor.constraint(equalTo: titleBudget.bottomAnchor, constant: 8),
            spendingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
        ])
    }
    
    @objc func seeAllButtonTapped() {
        
    }

}
