//
//  HomeViewController.swift
//  WiseSplit
//
//  Created by beni garcia on 02/04/24.
//

import Foundation
import UIKit
import FirebaseAuth
import SwiftUI
import Charts

class HomeViewController: UIViewController {
    var homeVM: HomeViewModel?
    var titleLabel = UILabel()
    var themeButton = UIButton()
    var numBudget = UILabel()
    var titleBudget = UILabel()
    var spendingTitle = UILabel()
    var spendingButton = UIButton()
    var account: Account?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeVM = HomeViewModel()
        setupAccount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupAccount()
    }
    
    private func setupAccount() {
        homeVM?.fetchAccount(completion: { [weak self] account in
            guard let self = self else { return }
            self.account = account
            DispatchQueue.main.async {
                self.setupHome()
            }
        })
    }
    
    private func setupHome() {
        titleLabel.text = "Hai, \(account?.nickname ?? "Guest")"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        let theme = UserDefaults.standard.string(forKey: "Theme") ?? "light"
        themeButton.setImage(UIImage(systemName: theme == "dark" ? "sun.max" : "moon.fill"), for: .normal)
        themeButton.tintColor = .yellowCustom
        themeButton.translatesAutoresizingMaskIntoConstraints = false
        themeButton.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
        view.addSubview(themeButton)
        
        numBudget.text = "\(formatToIDR(account?.budget ?? 0))"
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
            
            themeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            themeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            numBudget.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            numBudget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            titleBudget.topAnchor.constraint(equalTo: numBudget.bottomAnchor, constant: 4),
            titleBudget.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            spendingTitle.topAnchor.constraint(equalTo: titleBudget.bottomAnchor, constant: 16),
            spendingTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            spendingButton.topAnchor.constraint(equalTo: titleBudget.bottomAnchor, constant: 8),
            spendingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        setupBarChart()
    }
    
    func setupBarChart() {
        let barChartsView = BarChartsView()
        let hostingController = UIHostingController(rootView: barChartsView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: spendingTitle.bottomAnchor, constant: 16),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            hostingController.view.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.45)
        ])
    }
    
    @objc func seeAllButtonTapped() {
        let historyPaymentVC = HistoryPaymentViewController()
        navigationController?.pushViewController(historyPaymentVC, animated: true)
    }
    
    @objc private func changeTheme() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let interfaceStyle = window?.overrideUserInterfaceStyle == .unspecified ? UIScreen.main.traitCollection.userInterfaceStyle : window?.overrideUserInterfaceStyle
        
        if interfaceStyle == .light {
            window?.overrideUserInterfaceStyle = .dark
            window?.backgroundColor = .black
            UserDefaults.standard.setValue("dark", forKey: "Theme")
            themeButton.setImage(UIImage(systemName: interfaceStyle == .light ? "sun.max" : "moon.fill"), for: .normal)
        } else {
            window?.overrideUserInterfaceStyle = .light
            window?.backgroundColor = .white
            UserDefaults.standard.setValue("light", forKey: "Theme")
            themeButton.setImage(UIImage(systemName: interfaceStyle == .light ? "sun.max" : "moon.fill"), for: .normal)
        }
    }
}
