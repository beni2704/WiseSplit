
import UIKit

struct AppTheme {
    static let backgroundColor = UIColor.white
    static let textColor = UIColor.black
    static let textFieldBorderColor = UIColor.gray
    static let green = UIColor.systemGreen
    static let gray = UIColor.systemGray
}

struct ItemView {
    let itemButton: UIButton
    let assignedUserScrollView: UIScrollView
    let assignedUserStackView: UIStackView
}

class EditBillViewController: UIViewController, UITextFieldDelegate, SearchFriendDelegate {
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
    var confirmationShown = false
    var billNameTextField = UITextField()
    var itemNames: [String] = []
    var quantities: [String] = []
    var prices: [String] = []
    let scrollView = UIScrollView()
    
    var userStackView = UIStackView()
    var itemViews: [ItemView] = []
    
    var paymentDetail = UILabel()
    
    var users: [PersonTotal] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editBillVM = EditSplitBillViewModel()
        searchFriendViewController?.delegate = self
        fetchCurrentUser()
        calculateSubtotal()
        setup()
        
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
        
        billNameTextField.placeholder = "Enter Bill Name"
        billNameTextField.borderStyle = .none
        billNameTextField.layer.borderColor = AppTheme.textFieldBorderColor.cgColor
        billNameTextField.textColor = AppTheme.textColor
        billNameTextField.backgroundColor = .clear
        billNameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(billNameTextField)
        
        
        
        var frameHeight = backgroundView.bounds
        frameHeight.size.height -= 278 // Adjust height as needed
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
        userButton.backgroundColor = .lightGray
        userButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        userStackView.addArrangedSubview(userButton)
        //}
        
        //        userStackView.widthAnchor.constraint(greaterThanOrEqualTo: horizontalScrollView.widthAnchor).isActive = true
        
        //        if let lastButton = previousButton {
        //            lastButton.trailingAnchor.constraint(equalTo: userContainerView.trailingAnchor).isActive = true
        //        }
        
        let itemCount = min(itemNames.count, min(quantities.count, prices.count))
        
        var itemYOffset: CGFloat = 0
        for index in 0..<itemCount {
            
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            
            let itemButton = UIButton(type: .system)
            itemButton.setTitle("\(itemName) - Quantity: \(quantity), \t\t\t\t \(formatToIDR(Int(price) ?? 0))", for: .normal)
            //width harusnya sama dengan buttonWidth
            itemButton.setTitleColor(.black, for: .normal)
            
            itemButton.frame = CGRect(x: -10, y: itemYOffset, width: 400, height: 30)
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
            
            let dividerLine = UIView(frame: CGRect(x: 0, y: itemYOffset + 79, width: scrollView.bounds.width, height: 1))
            dividerLine.backgroundColor = UIColor.gray
            scrollView.addSubview(dividerLine)
            
            
            itemButtons.append(itemButton)
            itemViews.append(ItemView(itemButton: itemButton, assignedUserScrollView: assignedUserScrollView, assignedUserStackView: assignedUserStackView))
            
            itemYOffset += 76
            contentHeight += 74
        }
        itemYOffset = 242
        scrollView.contentSize = CGSize(width: 300, height: contentHeight)
        
        let labels = ["Subtotal:", "Tax:", "Service Tax:", "Discounts:", "Others:", "Total Amount:"]
        let values = [subtotal, tax, serviceTax, discounts, others, totalAmount]
        var textFields: [UITextField] = [subtotalTF, taxTF, serviceTaxTF, discountsTF, othersTF, totalAmountTF]
        var labelViews: [UILabel] = []
        
        
        for (index, labelText) in labels.enumerated() {
            let label = UILabel(frame: CGRect(x: 50, y: itemYOffset, width: 100, height: 30))
            label.text = labelText
            label.textColor = .black // Adjust color as needed
            label.font = UIFont.systemFont(ofSize: 14)
            backgroundView.addSubview(label)
            
            let valuesLabel = UILabel(frame: CGRect(x: 290, y: itemYOffset, width: 100, height: 30))
            valuesLabel.text = String(values[index]) // Set the value from the values array
            valuesLabel.textColor = .black // Adjust color as needed
            valuesLabel.font = UIFont.systemFont(ofSize: 14)
            backgroundView.addSubview(valuesLabel)
            
            let textField = textFields[index]
            textField.frame =  CGRect(x: 290, y: itemYOffset, width: 50, height: 30)
            textField.borderStyle = .none
            textField.backgroundColor = .clear
            textField.layer.borderColor = AppTheme.textFieldBorderColor.cgColor
            textField.textColor = AppTheme.textColor
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
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        backgroundView.addSubview(editButton)
        
        let confirmButton = UIButton(type: .system)
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
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
            backgroundView.topAnchor.constraint(equalTo: billNameTextField.bottomAnchor),            //backgroundView.widthAnchor.constraint(equalToConstant: 327),
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
            
            confirmButton.topAnchor.constraint(equalTo: editButton.topAnchor),
            confirmButton.leadingAnchor.constraint(equalTo: editButton.trailingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    
    func createTextField(withText text: String, frame: CGRect, tag: Int) -> UITextField {
        let textField = UITextField(frame: frame)
        textField.text = text
        textField.borderStyle = .none
        textField.layer.borderColor = AppTheme.textFieldBorderColor.cgColor
        textField.textColor = AppTheme.textColor
        textField.backgroundColor = .clear
        textField.delegate = self
        textField.tag = tag
        return textField
    }
    
    func calculateSubtotal() {
        subtotal = prices.compactMap { Double($0) }.reduce(0, +)
        
        // Example calculations for tax, service tax, discounts, others, and total amount
        tax = subtotal * 0.1
        serviceTax = subtotal * 0.05
        discounts = subtotal * 0.1
        others = 15.0
        totalAmount = subtotal + tax + serviceTax - discounts + others
    }
    
    func updateUI() {
        subtotalTF.text = String(format: "%.2f", subtotal)
        taxTF.text = String(format: "%.2f", tax)
        serviceTaxTF.text = String(format: "%.2f", serviceTax)
        discountsTF.text = String(format: "%.2f", discounts)
        othersTF.text = String(format: "%.2f", others)
        totalAmountTF.text = String(format: "%.2f", totalAmount)
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
        //additionalNominal.forEach { $0.isHidden = !isEditing }
        valuesLabels.forEach { $0.isHidden = isEditing } // Toggle visibility of valuesLabels
        
        
        if !isEditing {
            updateValuesLabels()
        }
        
    }
    
    func updateValuesLabels() {
        
        subtotal = Double(subtotalTF.text ?? "0") ?? 0.0
        tax = Double(taxTF.text ?? "0") ?? 0.0
        serviceTax = Double(serviceTaxTF.text ?? "0") ?? 0.0
        discounts = Double(discountsTF.text ?? "0") ?? 0.0
        others = Double(othersTF.text ?? "0") ?? 0.0
        totalAmount = Double(totalAmountTF.text ?? "0") ?? 0.0
        
        let values = [subtotal, tax, serviceTax, discounts, others, totalAmount]
        
        for (index, valueLabel) in valuesLabels.enumerated() {
            valueLabel.text = String(format: "%.2f", values[index])
        }
    }
    
    func updateButtonTitles() {
        var itemYOffset: CGFloat = 0
        for (index, button) in itemButtons.enumerated() {
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            button.frame = CGRect(x: -10, y: itemYOffset, width: 400, height: 30)
            button.setTitle("\(itemName) - Quantity: \(quantity), \t\t\t\tPrice: \(price)", for: .normal)
            
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
    
    
    @objc private func confirmButtonTapped() {
        guard let selectedUser = selectedUser else {
            presentingAlert(title: "Error", message: "No Selected User", view: self)
            return
        }
        
        guard let billName = billNameTextField.text, !billName.isEmpty else {
            presentingAlert(title: "Error", message: "Bill Name can't be empty", view: self)
            return
        }
        self.addLoading(onView: self.view)
        for index in users.indices {
            var totalPrice = 0
            for itemName in users[index].items {
                totalPrice += itemName.price
            }
            users[index].totalAmount = Int(Double(totalPrice))
        }
        
        saveSplitBill { [weak self] success in
            guard let self = self else { return }
            
            if success {
                let resultVC = ResultViewController(splitBillId: self.splitBillId ?? "empty")
                resultVC.isComplete = true
                self.navigationController?.pushViewController(resultVC, animated: true)
            } else {
                print("error saving")
                removeLoading()
            }
        }
    }
    
    func saveSplitBill(completion: @escaping (Bool) -> Void) {
        guard let billName = billNameTextField.text, !billName.isEmpty else {
            presentingAlert(title: "Error", message: "Bill Name can't be empty", view: self)
            return
        }
        
        let newSplitBill = SplitBill(title: billName, date: Date(), total: Int(totalAmount), image: capturedImage, imageUrl: "", personTotals: users, ownerId: editBillVM?.currUserId() ?? "nil")
        editBillVM?.saveSplitBill(splitBill: newSplitBill, completion: { result in
            switch result {
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
    
    
    @objc private func editButtonPressed2() {
        guard let selectedUser = selectedUser else {
            // Handle case where no user is selected
            return
        }
        
        let selectedUsers = [selectedUser]
        
        let viewController = OweResultViewController(displayedUser: selectedUsers, paymentMethod: "", accountName: "", accountNumber: "")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    @objc private func itemButtonTapped(_ sender: UIButton) {
        
        guard let selectedItemTitle = sender.currentTitle else { return }
        
        
        guard !users.isEmpty else {
            showAlert(title: "Error", message: "No users available. Please add users first.")
            return
        }
        
        guard var selectedUser = self.selectedUser else {
            showAlert(title: "Error", message: "Please select a user first.")
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
            userItemButton.backgroundColor = .clear
            userItemButton.setTitleColor(.systemBlue, for: .normal)
            userItemButton.layer.cornerRadius = 8
            userItemButton.addTarget(self, action: #selector(userItemButtonTapped(_:)), for: .touchUpInside)
                    
            assignedUserStackView.addArrangedSubview(userItemButton)
        }
        
        print("Added \(selectedItemTitle) to \(selectedUser.personName)'s assigned items.")
        showResults()
        
        UIView.animate(withDuration: 0.2, animations: {
            sender.backgroundColor = .yellow
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
            showAlert(title: "Error", message: "No user selected.")
            return
        }
        
        guard let index = itemViews.firstIndex(where: { $0.assignedUserStackView === sender.superview }) else {
            showAlert(title: "Error", message: "Failed to find the item.")
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
        selectedUser = users.first(where: { $0.personName == tappedUserName })
        
        sender.backgroundColor = .yellow
        sender.setTitleColor(.black, for: .normal)
        sender.layer.cornerRadius = 8
        for button in userStackView.subviews.compactMap({ $0 as? UIButton }) {
            if button != sender {
                button.backgroundColor = .clear
                button.setTitleColor(.systemBlue, for: .normal)
                button.layer.cornerRadius = 0
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
