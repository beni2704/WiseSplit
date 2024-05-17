
import UIKit

struct AppTheme {
    static let backgroundColor = UIColor.white
    static let textColor = UIColor.black
    static let textFieldBorderColor = UIColor.gray
    static let green = UIColor.systemGreen
    static let gray = UIColor.systemGray
    
}

struct User {
    let name: String
    var assignedItems: [String] = []
    var total: Int
}

class EditBillViewController: UIViewController, UITextFieldDelegate {
    
    var titleLabel = UILabel()
    var firstText = UILabel()
    var secondText = UILabel()
    
    var subtotal = UILabel()
    var tax = UILabel()
    var serviceTax = UILabel()
    var discounts = UILabel()
    var others = UILabel()
    var totalAmount = UILabel()
    
    var itemNames: [String] = ["item1", "item2", "item3", "item4", "item5"]
    var quantities: [String] = ["1", "2", "3", "4", "5"]
    var prices: [String] = ["20", "30", "40", "50", "60"]
    let scrollView = UIScrollView()
    
    var userStackView = UIStackView()
    
    var users: [User] = [
//        User(name: "Person A", total: 0),
//        User(name: "Person B", total: 0),
//        User(name: "Person C", total: 0),
//        User(name: "Person D", total: 0),
//        User(name: "Person E", total: 0),
//        User(name: "Person F", total: 0),
//        User(name: "Person A", total: 0),
//        User(name: "Person B", total: 0),
//        User(name: "Person C", total: 0),
//        User(name: "Person D", total: 0),
//        User(name: "Person E", total: 0),
//        User(name: "Person F", total: 0),
//        User(name: "Person A", total: 0),
//        User(name: "Person B", total: 0),
//        User(name: "Person C", total: 0),
//        User(name: "Person D", total: 0),
//        User(name: "Person E", total: 0),
//        User(name: "Person F", total: 0)
    ]
    var selectedUser: User?
    var userButtons: [UIButton] = []
    
    var allTextFields = [UITextField]()
    var itemButtons: [UIButton] = []
    var contentHeight: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        titleLabel.text = "Separate Bill"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        firstText.text = "Edit your Item"
        firstText.font = UIFont.boldSystemFont(ofSize: 24)
        //firstText.font = UIFont.preferredFont(forTextStyle: .title1)
        
        firstText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstText)
        
        secondText.text = "Make sure to check that all items was read correctly."
        //secondText.font = UIFont.boldSystemFont(ofSize: 16)
        secondText.font = UIFont.preferredFont(forTextStyle: .caption1)
        secondText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondText)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .lightGray
        //        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        let boxWidth: CGFloat = 370
        let boxHeight: CGFloat = 524
        let x = (view.frame.width - boxWidth) / 2
        let y = (view.frame.height - boxHeight) / 2 + 100 // incraese buat turun y-axis
        backgroundView.frame = CGRect(x: x, y: y, width: boxWidth, height: boxHeight)
        backgroundView.layer.cornerRadius = 10
        view.addSubview(backgroundView)
        
        view.backgroundColor = AppTheme.backgroundColor
        
        
        var frameHeight = backgroundView.bounds
        frameHeight.size.height -= 350 // Adjust height as needed
        scrollView.frame = frameHeight
        // scrollView.frame = backgroundView.bounds
        
        //scrollView.frame = CGRect(x: x, y: y, width: 370, height: 524)
        scrollView.backgroundColor = .lightGray
        scrollView.layer.cornerRadius = 10
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        backgroundView.addSubview(scrollView)
        
        
        let horizontalScrollView = UIScrollView()
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.showsVerticalScrollIndicator = false

        self.view.addSubview(horizontalScrollView)
        
        NSLayoutConstraint.activate([
            horizontalScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            horizontalScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            horizontalScrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            horizontalScrollView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //let userStackView = UIStackView()
        userStackView.axis = .horizontal
        userStackView.spacing = 10
        userStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.addSubview(userStackView)

        NSLayoutConstraint.activate([
            userStackView.leadingAnchor.constraint(equalTo: horizontalScrollView.leadingAnchor),
            userStackView.trailingAnchor.constraint(equalTo: horizontalScrollView.trailingAnchor),
            userStackView.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 16),
            userStackView.bottomAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor)
        ])
                var previousButton: UIButton?
        
        
        
        var userYOffset: CGFloat = 0
        var leadingAnchor = scrollView.leadingAnchor
        
        //for user in users {
            let userButton = UIButton(type: .system)
            userButton.setTitle("+", for: .normal)
            userButton.setTitleColor(.black, for: .normal)
            userButton.backgroundColor = .lightGray
            userButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
            userStackView.addArrangedSubview(userButton)
        //}
        
        userStackView.widthAnchor.constraint(greaterThanOrEqualTo: horizontalScrollView.widthAnchor).isActive = true
        
//        if let lastButton = previousButton {
//            lastButton.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor).isActive = true
//        }
        
        let itemCount = min(itemNames.count, min(quantities.count, prices.count))
        
        var itemYOffset: CGFloat = 40
        for index in 0..<itemCount {
            
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            
            let button = UIButton(type: .system)
            button.setTitle("\(itemName) - Quantity: \(quantity), Price: \(price)", for: .normal)
            //width harusnya sama dengan buttonWidth
            button.frame = CGRect(x: 10, y: itemYOffset, width: 260, height: 30)
            button.addTarget(self, action: #selector(itemButtonTapped(_:)), for: .touchUpInside)
            //button.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(button)
            
            
            let nameTextField = createTextField(withText: itemNames[index], frame: CGRect(x: 50, y: itemYOffset, width: 100, height: 30), tag: index * 3)
            nameTextField.isHidden = true
            scrollView.addSubview(nameTextField)
            
            let quantityTextField = createTextField(withText: quantities[index], frame: CGRect(x: 170, y: itemYOffset, width: 60, height: 30), tag: index * 3 + 1)
            quantityTextField.isHidden = true
            scrollView.addSubview(quantityTextField)
            
            let priceTextField = createTextField(withText: prices[index], frame: CGRect(x: 240, y: itemYOffset, width: 100, height: 30), tag: index * 3 + 2)
            priceTextField.isHidden = true
            scrollView.addSubview(priceTextField)
            
            allTextFields.append(contentsOf: [nameTextField, quantityTextField, priceTextField])
            
            
            
            let dividerLine = UIView(frame: CGRect(x: 0, y: itemYOffset + 39, width: scrollView.bounds.width, height: 1)) // Adjust the height and color as needed
            dividerLine.backgroundColor = UIColor.gray // Adjust the color as needed
            scrollView.addSubview(dividerLine)
            
            
            itemButtons.append(button)
            
            itemYOffset += 40
            contentHeight += 41
        }
        scrollView.contentSize = CGSize(width: 300, height: contentHeight)
        
        let labels = ["Subtotal:", "Tax:", "Service Tax:", "Discounts:", "Others:", "Total Amount:"]
        var labelViews: [UILabel] = []
        
        for (index, labelText) in labels.enumerated() {
            let label = UILabel(frame: CGRect(x: 50, y: itemYOffset, width: 100, height: 30))
            label.text = labelText
            label.textColor = AppTheme.textColor
            label.font = UIFont.systemFont(ofSize: 14)
            backgroundView.addSubview(label)
            
            labelViews.append(label)
            
            itemYOffset += 40
            contentHeight += 40
        }
        
        //            // Set scrollView content size
        //            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: contentHeight)
        
        
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit Bill", for: .normal)
        editButton.setTitleColor(AppTheme.textColor, for: .normal)
        editButton.backgroundColor = AppTheme.gray
        editButton.frame = CGRect(x: 50, y: itemYOffset, width: 100, height: 30)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        backgroundView.addSubview(editButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(AppTheme.textColor, for: .normal)
        confirmButton.backgroundColor = AppTheme.green
        confirmButton.frame = CGRect(x: 240, y: itemYOffset, width: 100, height: 30)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        backgroundView.addSubview(confirmButton)
        
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            firstText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            firstText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 0),
            secondText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            //            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            backgroundView.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 100),            backgroundView.widthAnchor.constraint(equalToConstant: 327),
            //            backgroundView.heightAnchor.constraint(equalToConstant: 524),
            
            scrollView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: 327),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            confirmButton.topAnchor.constraint(equalTo: editButton.topAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
            
            
        ])
    }
    
    
    func createTextField(withText text: String, frame: CGRect, tag: Int) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.text = text
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = AppTheme.textFieldBorderColor.cgColor
        textField.textColor = AppTheme.textColor
        textField.delegate = self
        textField.tag = tag
        return textField
    }
    
    @objc func editButtonPressed() {
        isEditing.toggle() // Toggle the editing state
        
        for textField in allTextFields {
            textField.isEnabled = isEditing
            // Only change border style if editing state is true
            textField.borderStyle = isEditing ? .roundedRect : .none
        }
        
        // Toggle visibility of text fields and buttons based on editing state
        allTextFields.forEach { $0.isHidden = !isEditing }
        itemButtons.forEach { $0.isHidden = isEditing }
    }
    
    
    func updateButtonTitles() {
        for (index, button) in itemButtons.enumerated() {
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            button.setTitle("\(itemName) - Quantity: \(quantity), Price: \(price)", for: .normal)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let newValue = textField.text else { return }
        let tag = textField.tag
        
        switch tag {
        case _ where tag % 3 == 0:
            let index = tag / 3
            itemNames[index] = newValue
            print("New item name at index \(index): \(newValue)")
        case _ where (tag - 1) % 3 == 0:
            let index = (tag - 1) / 3
            quantities[index] = newValue
            print("New quantity at index \(index): \(newValue)")
        case _ where (tag - 2) % 3 == 0:
            let index = (tag - 2) / 3
            prices[index] = newValue
            print("New price at index \(index): \(newValue)")
        default:
            break
        }
        
        updateButtonTitles()
    }

    
    @objc private func confirmButtonTapped() {
        guard let selectedUser = selectedUser else {
            // Handle case where no user is selected
            return
        }
        let selectedUsers = [selectedUser]
        let viewController = ResultViewController(displayedUser: users)
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    
    @objc private func itemButtonTapped(_ sender: UIButton) {
        
        guard let selectedItemTitle = sender.currentTitle else { return }
        
        
        guard var selectedUser = self.selectedUser else {
            print("Please select a user first.")
            return
        }
        
        
        selectedUser.assignedItems.append(selectedItemTitle)
        
        
        if let index = users.firstIndex(where: { $0.name == selectedUser.name }) {
            users[index] = selectedUser
        }
        
        
        self.selectedUser = selectedUser
        
        
        print("Added \(selectedItemTitle) to \(selectedUser.name)'s assigned items.")
        showResults()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func showResults() {
        
        for user in users{
            print("\(user.name): \(user.assignedItems)")
        }
    }
    
    @objc private func userButtonTapped(_ sender: UIButton) {
        
        guard let tappedUserName = sender.currentTitle else { return }
        
        
        selectedUser = users.first(where: { $0.name == tappedUserName })
        
        
    }
    
    @objc func addButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Enter Button Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Button Name"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] (_) in
            if let buttonName = alertController.textFields?.first?.text, !buttonName.isEmpty {
                self?.addNewButtonWithName(buttonName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func addNewButtonWithName(_ name: String) {
        let newButton = UIButton(type: .system)
        newButton.setTitle(name, for: .normal)
        newButton.addTarget(self, action: #selector(userButtonTapped(_:)), for: .touchUpInside)
        
        userStackView.insertArrangedSubview(newButton, at: 0) // Insert at index 0 to add it to the left
        let newUser = User(name: name, total: 0)
        users.append(newUser)
    }

    
    @objc private func buttonTapped(_ sender: UIButton) {
        if let index = userStackView.arrangedSubviews.firstIndex(of: sender) {
            print("Button \(users[index]) tapped!")
        }
    }
    
}
