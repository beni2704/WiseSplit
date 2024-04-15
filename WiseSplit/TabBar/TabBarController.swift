//
//  TabBarController.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        let homeVC = HomeViewController()
        let budgetVC = AddBudgetViewController()
        let addBudgetVC = LoginViewController()
        let paymentVC = AddPaymentViewController()
        let profileVC = ProfileViewController()
        
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        budgetVC.tabBarItem = UITabBarItem(title: "Budget", image: UIImage(systemName: "dollarsign.circle"), selectedImage: UIImage(systemName: "dollarsign.circle.fill"))
        addBudgetVC.tabBarItem = UITabBarItem(title: "Split Bill", image: UIImage(systemName: "plus.circle"), selectedImage: UIImage(systemName: "plus.circle.fill"))
        paymentVC.tabBarItem = UITabBarItem(title: "Payment", image: UIImage(systemName: "dollarsign.square"), selectedImage: UIImage(systemName: "dollarsign.square.fill"))
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        viewControllers = [homeVC, budgetVC, addBudgetVC, paymentVC, profileVC]
    }
}
