
import UIKit

struct AppTheme {
    //    static let backgroundColor = UIColor.white
    //    static let textColor = UIColor.black
    //    static let textFieldBorderColor = UIColor.gray
    //    static let green = UIColor.systemGreen
    //    static let gray = UIColor.systemGray
}

struct ItemView {
    let itemButton: UIButton
    let assignedUserScrollView: UIScrollView
    let assignedUserStackView: UIStackView
}

class EditBillViewController: UIViewController, UITextFieldDelegate, SearchFriendDelegate {
    
    var allItemNames: [String] = []
    var allPrices: [Double] = []
    
    var titleLabel = UILabel()
    var firstText = UILabel()
    var secondText = UILabel()
    var capturedImage: UIImage?
    
    var subtotal: Double = 0.0
    var subtotalTF = UITextField()
    var subtotalLabel = UILabel()
    var tax: Double = 69.0
    var taxTF = UITextField()
    var taxLabel = UILabel()
    var serviceTax: Double = 0.0
    var serviceTaxTF = UITextField()
    var serviceTaxLabel = UILabel()
    var discounts: Double = 0.0
    var discountsTF = UITextField()
    var discountLabel = UILabel()
    var others: Double = 0.0
    var othersTF = UITextField()
    var othersLabel = UILabel()
    var totalAmount: Double = 0.0
    var totalAmountTF = UITextField()
    var totalAmountLabel = UILabel()
    
    let editButton = UIButton(type: .system)
    var removeButton = UIButton(type: .system)
    var confirmationShown = false
    var billNameTextField = PaddedTextField()
    var itemNames: [String] = []
    var quantities: [String] = []
    var prices: [String] = []
    let scrollView = UIScrollView()
    
    var userStackView = UIStackView()
    var itemViews: [ItemView] = []
    
    var paymentDetail = UILabel()
    
    var users: [PersonTotal] = []
    var isRemoveModeActive: Bool = false
    var selectedButton: UIButton?
    var selectedUser: PersonTotal?
    var userButtons: [UIButton] = []
    
    var allTextFields = [UITextField]()
    var itemButtons: [UIButton] = []
    var additionalNominal: [UILabel] = []
    var valuesLabels: [UILabel] = []
    var contentHeight: CGFloat = 20
    
    var splitBillId: String?
    
    var editBillVM: EditSplitBillViewModel?
    var searchFriendViewController: SearchFriendViewController?
    var itemCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        editBillVM = EditSplitBillViewModel()
        searchFriendViewController?.delegate = self
        fetchCurrentUser()
        calculateSubtotal()
        setup()
        getAllPrices()
        updateUI()
        
    }
    
    func didSelectUser(_ user: PersonTotal) {
        let newButton = UIButton(type: .system)
        newButton.setTitle(user.personName, for: .normal)
        newButton.addTarget(self, action: #selector(userButtonTapped(_:)), for: .touchUpInside)
        
        userStackView.insertArrangedSubview(newButton, at: 0)
        
        let newUser = PersonTotal(personUUID: user.personUUID, personName: user.personName, personPhoneNumber: user.personPhoneNumber, totalAmount: 0, items: [], isPaid: false, imagePaidUrl: "")
        users.append(newUser)
    }
    
    private func fetchCurrentUser() {
        editBillVM?.fetchLoginAccount { [weak self] result in
            switch result {
            case .success(let accountData):
                let newButton = UIButton(type: .system)
                newButton.setTitle(accountData.personName, for: .normal)
                newButton.addTarget(self, action: #selector(self?.userButtonTapped(_:)), for: .touchUpInside)
                
                self?.userStackView.insertArrangedSubview(newButton, at: 0)
                self?.users.append(accountData)
            case .failure(let error):
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
        backgroundView.backgroundColor = Colors.backgroundChartCustom
        //        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        let boxWidth: CGFloat = 370
        let boxHeight: CGFloat = 524
        let x = (view.frame.width - boxWidth) / 2
        let y = (view.frame.height - boxHeight) / 2 + 100 // incraese buat turun y-axis
        backgroundView.frame = CGRect(x: x, y: y, width: boxWidth, height: boxHeight)
        backgroundView.layer.cornerRadius = 10
        view.addSubview(backgroundView)
        
        billNameTextField.placeholder = "Enter Bill Name"
        billNameTextField.backgroundColor = Colors.backgroundFormCustom
        billNameTextField.layer.cornerRadius = 8
        billNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(billNameTextField)
        
        var frameHeight = backgroundView.bounds
        frameHeight.size.height -= 278 // Adjust height as needed
        scrollView.frame = frameHeight
        // scrollView.frame = backgroundView.bounds
        
        //scrollView.frame = CGRect(x: x, y: y, width: 370, height: 524)
        scrollView.backgroundColor = Colors.backgroundChartCustom
        scrollView.layer.cornerRadius = 10
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        backgroundView.addSubview(scrollView)
        
        
        let horizontalScrollView = UIScrollView()
        
        horizontalScrollView.translatesAutoresizingMaskIntoConstraints = false
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(horizontalScrollView)
        
        NSLayoutConstraint.activate([
            horizontalScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            horizontalScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
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
        
        //for user in users {
        let userButton = UIButton(type: .system)
        userButton.setTitle("+", for: .normal)
        userButton.setTitleColor(.black, for: .normal)
        
        userButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        userStackView.addArrangedSubview(userButton)
        
        removeButton.setTitle("-", for: .normal)
        removeButton.setTitleColor(.black, for: .normal)
        
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        userStackView.addArrangedSubview(removeButton)
        
        //}
        
        //        userStackView.widthAnchor.constraint(greaterThanOrEqualTo: horizontalScrollView.widthAnchor).isActive = true
        
        //        if let lastButton = previousButton {
        //            lastButton.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor).isActive = true
        //        }
        
        itemCount = min(itemNames.count, min(quantities.count, prices.count))
        
        var itemYOffset: CGFloat = 0
        subtotal = 0
        for index in 0..<itemCount {
            
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = Double(prices[index]) ?? 0.0
            
            subtotal += price
            
            allItemNames.append(itemName)
            allPrices.append(price)
            
            let itemButton = UIButton(type: .system)
            itemButton.setTitle("\(itemName) - \(quantity)x, \t\t\t\t \(formatToIDR(Int(price) ))", for: .normal)
            //width harusnya sama dengan buttonWidth
            itemButton.setTitleColor(.black, for: .normal)
            
            itemButton.frame = CGRect(x: -10, y: itemYOffset, width: 400, height: 40)
            itemButton.addTarget(self, action: #selector(itemButtonTapped(_:)), for: .touchUpInside)
            //button.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(itemButton)
            
            
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
            
            let assignedUserScrollView = UIScrollView()
            
            assignedUserScrollView.translatesAutoresizingMaskIntoConstraints = false
            assignedUserScrollView.showsHorizontalScrollIndicator = false
            assignedUserScrollView.showsVerticalScrollIndicator = false
            
            scrollView.addSubview(assignedUserScrollView)
            
            NSLayoutConstraint.activate([
                assignedUserScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
                assignedUserScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
                assignedUserScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: itemYOffset + 40),
                assignedUserScrollView.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            let assignedUserStackView = UIStackView()
            assignedUserStackView.axis = .horizontal
            assignedUserStackView.spacing = 10
            assignedUserStackView.translatesAutoresizingMaskIntoConstraints = false
            assignedUserScrollView.addSubview(assignedUserStackView)
            
            NSLayoutConstraint.activate([
                assignedUserStackView.leadingAnchor.constraint(equalTo: assignedUserScrollView.leadingAnchor),
                assignedUserStackView.trailingAnchor.constraint(equalTo: assignedUserScrollView.trailingAnchor),
            ])
            
            let dividerLine = UIView(frame: CGRect(x: 0, y: itemYOffset + 81, width: scrollView.bounds.width, height: 1))
            dividerLine.backgroundColor = UIColor.gray
            scrollView.addSubview(dividerLine)
            
            let tapLabel = UILabel(frame: CGRect(x: 16, y: itemYOffset + 65, width: scrollView.bounds.width - 32, height: 20))
                tapLabel.text = "Tap to assign/remove"
                tapLabel.textColor = .black
                tapLabel.textAlignment = .left
                tapLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
                scrollView.addSubview(tapLabel)
            
            itemButtons.append(itemButton)
            itemViews.append(ItemView(itemButton: itemButton, assignedUserScrollView: assignedUserScrollView, assignedUserStackView: assignedUserStackView))
            
            itemYOffset += 76
            contentHeight += 74
            print("price: \(price)")
            print("subtotal: \(subtotal)")
        }
        
        itemYOffset = 242
        scrollView.contentSize = CGSize(width: 300, height: contentHeight)
        
        let labels = ["Total: "]
        let values = [subtotal]
        var textFields: [UITextField] = [subtotalTF]
        var labelViews: [UILabel] = []
        
        
        for (index, labelText) in labels.enumerated() {
            let label = UILabel(frame: CGRect(x: 50, y: itemYOffset, width: 100, height: 30))
            label.text = labelText
            label.textColor = .black // Adjust color as needed
            label.font = UIFont.systemFont(ofSize: 14)
            backgroundView.addSubview(label)
            
            let valuesLabel = UILabel(frame: CGRect(x: 250, y: itemYOffset, width: 100, height: 30))
            valuesLabel.text = formatToIDR(Int(values[index]))
            //valuesLabel.text = ""
            valuesLabel.textColor = .black // Adjust color as needed
            valuesLabel.font = UIFont.systemFont(ofSize: 14)
            backgroundView.addSubview(valuesLabel)
            
            let textField = textFields[index]
            textField.frame =  CGRect(x: 290, y: itemYOffset, width: 100, height: 30)
            textField.borderStyle = .none
            textField.layer.borderColor = UIColor.gray.cgColor
            textField.backgroundColor = .clear
            textField.isHidden = true
            backgroundView.addSubview(textField)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            backgroundView.addGestureRecognizer(tapGesture)
            
            valuesLabels.append(valuesLabel)
            labelViews.append(label)
            allTextFields.append(textField)
            
            itemYOffset += 40
            contentHeight += 40
        }
        
        //            // Set scrollView content size
        //            scrollView.contentSize = CGSize(width: scrollView.contentSize.width, height: contentHeight)
        
        editButton.setTitle("Edit Bill", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.backgroundColor = .black
        editButton.frame = CGRect(x: 50, y: itemYOffset, width: 100, height: 30)
        editButton.layer.cornerRadius = 12
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        backgroundView.addSubview(editButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = Colors.greenCustom
        confirmButton.layer.cornerRadius = 12
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
            backgroundView.topAnchor.constraint(equalTo: billNameTextField.bottomAnchor, constant: 8),            //backgroundView.widthAnchor.constraint(equalToConstant: 327),
            //            backgroundView.heightAnchor.constraint(equalToConstant: 524),
            billNameTextField.topAnchor.constraint(equalTo: horizontalScrollView.bottomAnchor, constant: 16),
            billNameTextField.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            billNameTextField.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 16),
            scrollView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: 327),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editButton.heightAnchor.constraint(equalToConstant: 44),
            
            confirmButton.topAnchor.constraint(equalTo: editButton.topAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    func createTextField(withText text: String, frame: CGRect, tag: Int) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.text = text
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.tag = tag
        return textField
    }
    
    func getAllPrices() {
        for (index, price) in allPrices.enumerated() {
            print("Item \(index + 1): \(price)")
            //subtotal += price
            
        }
        print("new: \(subtotal)")
    }
    
    func calculateSubtotal() {
        subtotal = 0.0
        
        for newPrice in allPrices{
            subtotal += Double(newPrice)
        }
        
        //subtotal = allPrices.enumerated().reduce(0.0) { $0 + (Double($1.element) ?? 0.0) }
        
        // Example calculations for tax, service tax, discounts, others, and total amount
        //        tax = subtotal * 0.1
        //        serviceTax = subtotal * 0.05
        //        discounts = subtotal * 0.1
        //        others = 15.0
        //        totalAmount = subtotal + tax + serviceTax - discounts + others
    }
    
    func updateUI() {
        subtotalTF.text = formatToIDR(Int(subtotal))
        //        taxTF.text = formatToIDR(Int(subtotal))
        //        serviceTaxTF.text = formatToIDR(Int(serviceTax))
        //        discountsTF.text = formatToIDR(Int(discounts))
        //        othersTF.text = formatToIDR(Int(others))
        //        totalAmountTF.text = formatToIDR(Int(totalAmount))
        
        //subtotalTF.text = ""
        taxTF.text = ""
        serviceTaxTF.text = ""
        discountsTF.text = ""
        othersTF.text = ""
        totalAmountTF.text = ""
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
        additionalNominal.forEach { $0.isHidden = !isEditing }
        valuesLabels.forEach { $0.isHidden = isEditing } // Toggle visibility of valuesLabels
        
        
        if !isEditing {
            allItemNames.removeAll()
            for index in 0..<itemCount {
                
                if let itemNameTextField = scrollView.viewWithTag(index * 3) as? UITextField {
                    let itemName = itemNameTextField.text ?? ""
                    allItemNames.append(itemName)
                }
            }
            
            updateValuesLabels()
        }
        
    }
    
    func updateValuesLabels() {
        
        subtotal = Double(subtotalTF.text ?? "0") ?? subtotal
        tax = Double(taxTF.text ?? "0") ?? 0.0
        serviceTax = Double(serviceTaxTF.text ?? "0") ?? 0.0
        discounts = Double(discountsTF.text ?? "0") ?? 0.0
        others = Double(othersTF.text ?? "0") ?? 0.0
        totalAmount = Double(totalAmountTF.text ?? "0") ?? 0.0
        
        
        
        let values = [subtotal, tax, serviceTax, discounts, others, totalAmount]
        
        for (index, valueLabel) in valuesLabels.enumerated() {
            //            valueLabel.text = String(format: "%.2f", values[index])
            valueLabel.text = formatToIDR(Int(values[index]))
        }
    }
    
    func updateButtonTitles() {
        var itemYOffset: CGFloat = 0
        for (index, button) in itemButtons.enumerated() {
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            button.frame = CGRect(x: -10, y: itemYOffset, width: 400, height: 30)
            button.setTitle("\(itemName) - \(quantity)x, \t\t\t\tPrice: \(formatToIDR(Int(price) ?? 0))", for: .normal)
            
            itemYOffset += 76
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
        calculateSubtotal()
        updateButtonTitles()
    }
    
    @objc private func removeButtonTapped() {
        guard var selectedUser = selectedUser else {
            presentingAlert(title: "Error", message: "Please select a user first.", view: self)
            return
        }
        
        let viewModel = ResultViewModel()
        if viewModel.isOwner(splitBillOwnerId: selectedUser.personUUID) {
            presentingAlert(title: "Error", message: "You cannot remove the owner.", view: self)
            return
        }
        
        let confirmationAlert = UIAlertController(title: "Confirmation", message: "Are you sure you want to remove the current user?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { [self] _ in
            // Find the user item button in the stack view
            guard let selectedButton = self.userStackView.arrangedSubviews.first(where: {
                ($0 as? UIButton)?.currentTitle == selectedUser.personName
            }) as? UIButton else {
                return
            }
            
            
            // Find the user item button in the stack view
            guard let selectedButton = userStackView.arrangedSubviews.first(where: {
                ($0 as? UIButton)?.currentTitle == selectedUser.personName
            }) as? UIButton else {
                return
            }
            
            // Remove the button from the stack view
            userStackView.removeArrangedSubview(selectedButton)
            selectedButton.removeFromSuperview()
            
            for itemView in itemViews {
                let stackView = itemView.assignedUserStackView
                
                // Find all buttons with the selected user's name and remove them
                for view in stackView.arrangedSubviews {
                    if let button = view as? UIButton, button.currentTitle == selectedUser.personName {
                        stackView.removeArrangedSubview(button)
                        button.removeFromSuperview()
                    }
                }
            }
            
            
            // Remove the user and their assigned items from the users array
            users.removeAll { $0.personName == selectedUser.personName }
            
            // Clear the selected user reference
            self.selectedUser = nil
            
            print("Removed \(selectedButton.currentTitle ?? "") and their assigned items.")
            
            // Optionally, update the UI or show a confirmation message
            presentingAlert(title: "Success", message: "User and their assigned items have been removed.", view: self)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        confirmationAlert.addAction(confirmAction)
        confirmationAlert.addAction(cancelAction)
        
        present(confirmationAlert, animated: true, completion: nil)
    }
    
    private func removeCurrButton(button: UIButton) {
        // Remove the button from the userStackView
        userStackView.removeArrangedSubview(button)
        button.removeFromSuperview()
        
        // Find the user associated with the button
        guard let username = button.currentTitle,
              let userIndex = users.firstIndex(where: { $0.personName == username }) else {
            return
        }
        
        // Remove all buttons from the assignedUserStackView for the selected user
        let selectedUser = users[userIndex]
        for itemView in itemViews {
            for subview in itemView.assignedUserStackView.arrangedSubviews {
                if let userButton = subview as? UIButton, userButton.currentTitle == username {
                    itemView.assignedUserStackView.removeArrangedSubview(userButton)
                    userButton.removeFromSuperview()
                }
            }
        }
        
        // Clear the assigned items for the selected user and remove the user from the users array
        users[userIndex].items.removeAll()
        users.remove(at: userIndex)
        
        print("Removed \(username) and their assigned items.")
    }
    
    @objc private func confirmButtonTapped() {
        // Debug: Print start of function
        print("Starting confirmButtonTapped function")
        
        // Initialize assignedItemSet
        var assignedItemSet = Set<String>()
        for user in users {
            for assignedItem in user.items {
                let itemName = assignedItem.name // Directly access the name property
                assignedItemSet.insert(itemName)
                // Debug: Print each assigned item name
                print("Assigned item name: \(itemName)")
            }
        }
        
        // Debug: Print assigned item set and item names
        print("Assigned item set: \(assignedItemSet)")
        print("Item names: \(itemNames)")
        
        // Check if every item is assigned to at least one user
        for itemName in allItemNames {
            if !assignedItemSet.contains(itemName) {
                presentingAlert(title: "Error", message: "Every item must be assigned.", view: self)
                // Debug: Print missing item
                print("Missing item: \(itemName)")
                return
            }
        }
        
        // Ensure bill name is not empty
        guard let billName = billNameTextField.text, !billName.isEmpty else {
            presentingAlert(title: "Error", message: "Bill Name can't be empty", view: self)
            // Debug: Print bill name check failure
            print("Bill name is empty")
            return
        }
        
        // Check if every user has at least one assigned item
        for user in users {
            if user.items.isEmpty {
                presentingAlert(title: "Error", message: "Every user must be assigned.", view: self)
                // Debug: Print user with no assigned items
                print("User with no assigned items: \(user.personName)")
                return
            }
        }
        
        // Add loading indicator
        self.addLoading(onView: self.view)
        // Debug: Print before calculating total amount
        print("Calculating total amount for each user")
        
        // Calculate total amount for each user
        for index in users.indices {
            var totalPrice = 0
            for item in users[index].items {
                totalPrice += item.price
            }
            users[index].totalAmount = totalPrice
            // Debug: Print total amount for each user
            print("User: \(users[index].personName), Total Amount: \(users[index].totalAmount)")
        }
        
        print("Saving split bill")
        
        saveSplitBill { [weak self] success in
            guard let self = self else { return }
            
            if success {
                print("Split bill saved successfully")
                let resultVC = ResultViewController(splitBillId: self.splitBillId ?? "empty")
                resultVC.isComplete = true
                resultVC.splitBillDetail?.total = Int(subtotal)
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                print("Error saving split bill")
                self.removeLoading()
            }
        }
    }
    
    
    func saveSplitBill(completion: @escaping (Bool) -> Void) {
        guard let billName = billNameTextField.text, !billName.isEmpty else {
            presentingAlert(title: "Error", message: "Bill Name can't be empty", view: self)
            return
        }
        
        let newSplitBill = SplitBill(title: billName, date: Date(), total: Int(subtotal), image: capturedImage, imageUrl: "", personTotals: users, ownerId: editBillVM?.currUserId() ?? "nil")
        
        editBillVM?.checkAmountUser(splitBill: newSplitBill, completion: { result in
            switch result {
            case .success(let valid):
                if !valid {
                    presentingAlert(title: "Your Budget not enough!", message: "Please add budget until sufficient amount", view: self)
                    self.removeLoading()
                    return
                }else if valid {
                    self.editBillVM?.saveSplitBill(splitBill: newSplitBill, completion: { res in
                        switch res {
                        case .success(let uid):
                            print(newSplitBill)
                            self.splitBillId = uid
                            completion(true)
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion(false)
                        }
                    })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    @objc private func itemButtonTapped(_ sender: UIButton) {
        
        guard let selectedItemTitle = sender.currentTitle else { return }
        
        
        guard !users.isEmpty else {
            presentingAlert(title: "Error", message: "No users available. Please add users first.", view: self)
            return
        }
        
        guard var selectedUser = self.selectedUser else {
            presentingAlert(title: "Error", message: "Please select a user first.", view: self)
            return
        }
        
        
        if let index = itemButtons.firstIndex(of: sender) {
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            
            guard let price = Double(price), let quantity = Double(quantity) else {
                return
            }
            let calculatedPrice = price / quantity
            //            selectedUser.assignedItems.append("\(itemName) - Quantity: 1, Price: \(String(format: "%.2f", calculatedPrice))")
            selectedUser.items.append(BillItem(name: itemName, quantity: 1, price: Int(calculatedPrice)))
            
            if let index = users.firstIndex(where: { $0.personName == selectedUser.personName }) {
                users[index] = selectedUser
            }
            
            self.selectedUser = selectedUser
            
            let assignedUserStackView = itemViews[index].assignedUserStackView
            
            let userItemButton = UIButton(type: .system)
            userItemButton.setTitle("\(selectedUser.personName)", for: .normal)
            userItemButton.backgroundColor = .white
            userItemButton.setTitleColor(.black, for: .normal)
            userItemButton.layer.borderWidth = 1.0
            userItemButton.layer.borderColor = UIColor.systemBlue.cgColor
            userItemButton.setTitleColor(.systemBlue, for: .normal)
            userItemButton.layer.cornerRadius = 12
            userItemButton.clipsToBounds = true
            userItemButton.addTarget(self, action: #selector(userItemButtonTapped(_:)), for: .touchUpInside)
            userItemButton.frame = CGRect(x: 50, y: 100, width: 200, height: 50)
            
            assignedUserStackView.addArrangedSubview(userItemButton)
        }
        
        print("Added \(selectedItemTitle) to \(selectedUser.personName)'s assigned items.")
        showResults()
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.backgroundColor = .green
            sender.setTitleColor(.black, for: .normal)
            sender.layer.cornerRadius = 8
        }) { (_) in
            UIView.animate(withDuration: 0.2) {
                sender.backgroundColor = .clear
                sender.setTitleColor(.systemBlue, for: .normal)
                sender.layer.cornerRadius = 0
            }
        }
    }
    
    @objc private func userItemButtonTapped(_ sender: UIButton) {
        guard var selectedUser = self.selectedUser else {
            presentingAlert(title: "Error", message: "No user selected.", view: self)
            return
        }
        
        guard let index = itemViews.firstIndex(where: { $0.assignedUserStackView === sender.superview }) else {
            presentingAlert(title: "Error", message: "Failed to find the item.", view: self)
            return
        }
        
        sender.removeFromSuperview()
        
        let itemName = itemNames[index]
        selectedUser.items.removeAll { $0.name == itemName }
        
        if let userIndex = users.firstIndex(where: { $0.personName == selectedUser.personName }) {
            users[userIndex] = selectedUser
        }
        
        self.selectedUser = selectedUser
        
        print("Removed \(itemName) from \(selectedUser.personName)'s assigned items.")
    }
    
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func showResults() {
        for user in users{
            print("\(user.personName): \(user.items)")
        }
    }
    
    @objc private func userButtonTapped(_ sender: UIButton) {
        guard let tappedUserName = sender.currentTitle else { return }
        
        // Find the user object corresponding to the tapped button
        selectedUser = users.first(where: { $0.personName == tappedUserName })
        selectedButton = sender
        
        if isRemoveModeActive {
            // Activate remove mode
            removeButtonTapped()
        } else {
            // Highlight the tapped button
            sender.backgroundColor = .green // You can change this to any highlight color
            sender.setTitleColor(.black, for: .normal) // Example of changing text color
            sender.layer.cornerRadius = 8 // Example of rounding corners for highlight effect
            
            // Reset other buttons
            for button in userStackView.subviews.compactMap({ $0 as? UIButton }) {
                if button != sender {
                    button.backgroundColor = .clear
                    button.setTitleColor(.systemBlue, for: .normal)
                    button.layer.cornerRadius = 0
                }
            }
        }
    }
    
    @objc func addButtonTapped() {
        guard !confirmationShown else {
            showSearchFriend()
            return
        }
        
        let confirmationAlert = UIAlertController(title: "Confirmation", message: "Did you finish editing the bill?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [weak self] (_) in
            self?.confirmationShown = true
            self?.editButton.isEnabled = false
            self?.editButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
            self?.showSearchFriend()
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        confirmationAlert.addAction(yesAction)
        confirmationAlert.addAction(noAction)
        
        present(confirmationAlert, animated: true, completion: nil)
        
    }
    
    @objc func showSearchFriend() {
        let searchFriendVC = SearchFriendViewController()
        searchFriendVC.delegate = self
        showSheet(vc: searchFriendVC, presentingVC: self)
        self.searchFriendViewController = searchFriendVC
    }
}
