//import UIKit
//
//struct User {
//    let name: String
//    var assignedItems: [String] = []
//}
//
//class SeparateBillViewController: UIViewController {
//    
//    var users: [User] = [
//        User(name: "Person A"),
//        User(name: "Person B"),
//        User(name: "Person C")
//    ]
//    
//    var itemNames: [String] = []
//    var quantities: [String] = []
//    var prices: [String] = []
//    var selectedUser: User?
//    
//    private var billDetailsLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        return label
//    }()
//    
//    private var resultsButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Show Results", for: .normal)
//        button.addTarget(self, action: #selector(showResults), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setupUI()
//        displayBillDetails()
//    }
//    
//    private func setupUI() {
//        
//        var userButtons: [UIButton] = []
//        var previousButton: UIButton?
//        for user in users.reversed() {
//            let button = UIButton(type: .system)
//            button.setTitle(user.name, for: .normal)
//            button.addTarget(self, action: #selector(userButtonTapped(_:)), for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(button)
//            userButtons.append(button)
//            
//            
//            NSLayoutConstraint.activate([
//                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//            ])
//            
//            if let previousButton = previousButton {
//                button.bottomAnchor.constraint(equalTo: previousButton.topAnchor, constant: -20).isActive = true
//            } else {
//                button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
//            }
//            
//            previousButton = button
//        }
//        
//        
//        let spacerView = UIView()
//        spacerView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(spacerView)
//        NSLayoutConstraint.activate([
//            spacerView.bottomAnchor.constraint(equalTo: userButtons.first?.topAnchor ?? view.safeAreaLayoutGuide.bottomAnchor),
//            spacerView.heightAnchor.constraint(equalToConstant: 0),
//            
//            spacerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            spacerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//        
//        
//        
//        view.addSubview(billDetailsLabel)
//        NSLayoutConstraint.activate([
//            billDetailsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            billDetailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            billDetailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//        
//        
//        view.addSubview(resultsButton)
//        NSLayoutConstraint.activate([
//            resultsButton.topAnchor.constraint(equalTo: billDetailsLabel.bottomAnchor, constant: 100),
//            resultsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//            
//        ])
//    }
//    
//    private func displayBillDetails() {
//        
//        billDetailsLabel.removeFromSuperview()
//        
//        
//        var yPosition: CGFloat = 20
//        let itemCount = min(itemNames.count, min(quantities.count, prices.count))
//        for index in 0..<itemCount {
//            let itemName = itemNames[index]
//            let quantity = quantities[index]
//            let price = prices[index]
//            
//            let button = UIButton(type: .system)
//            button.setTitle("\(itemName) - Quantity: \(quantity), Price: \(price)", for: .normal)
//            button.addTarget(self, action: #selector(itemButtonTapped(_:)), for: .touchUpInside)
//            button.translatesAutoresizingMaskIntoConstraints = false
//            view.addSubview(button)
//            
//            
//            NSLayoutConstraint.activate([
//                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: yPosition),
//                button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//            ])
//            
//            
//            yPosition += 40
//        }
//    }
//    
//    @objc private func userButtonTapped(_ sender: UIButton) {
//        
//        guard let tappedUserName = sender.currentTitle else { return }
//        
//        
//        selectedUser = users.first(where: { $0.name == tappedUserName })
//        
//        
//    }
//    
//    @objc private func itemButtonTapped(_ sender: UIButton) {
//        
//        guard let selectedItemTitle = sender.currentTitle else { return }
//        
//        
//        guard var selectedUser = self.selectedUser else {
//            print("Please select a user first.")
//            return
//        }
//        
//        
//        selectedUser.assignedItems.append(selectedItemTitle)
//        
//        
//        if let index = users.firstIndex(where: { $0.name == selectedUser.name }) {
//            users[index] = selectedUser
//        }
//        
//        
//        self.selectedUser = selectedUser
//        
//        
//        print("Added \(selectedItemTitle) to \(selectedUser.name)'s assigned items.")
//        showResults()
//    }
//    
//    
//    
//    
//    @objc private func showResults() {
//        
//        if let user = selectedUser {
//            print("\(user.name): \(user.assignedItems)")
//        }
//    }
//}
