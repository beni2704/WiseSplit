import UIKit


class OweResultViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    private var titleLabel = UILabel()
    private var firstText = UILabel()
    private var secondText = UILabel()
    private var balanceText = UILabel()
    private var oweText = UILabel()
    
    private let backgroundView = UIView()
    
    private let scrollView = UIScrollView()
    
    private var displayedUser: [PersonTotal] = []
    
    private var paymentInfo = UILabel()
    private var paymentDetail = UILabel()
    private var paymentMethod: String?
    private var accountName: String?
    private var accountNumber: String?
    
    private var itemYOffset: CGFloat = 40
    
    private var selectedImage: UIImage?
    
    // MARK: - Initialization
    
    init(displayedUser: [PersonTotal], paymentMethod: String, accountName: String, accountNumber: String) {
        self.displayedUser = displayedUser
        self.paymentMethod = paymentMethod
        self.accountName = accountName
        self.accountNumber = accountNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let paymentMethod = paymentMethod, let accountName = accountName, let accountNumber = accountNumber {
            paymentDetail.text = "\(paymentMethod) - \(accountName) - \(accountNumber)"
            
        }
        
        setupUI()
        
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupLabels()
        setupBackgroundView()
        setupScrollView()
        setupButtons()
        
        displayUser()
    }
    
    private func setupLabels() {
        titleLabel.text = "Total Amount"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        firstText.text = "Nama Restoran"
        firstText.font = UIFont.boldSystemFont(ofSize: 24)
        firstText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstText)
        
        secondText.text = "Bill Date"
        secondText.font = UIFont.preferredFont(forTextStyle: .caption1)
        secondText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(secondText)
        
        balanceText.text = "-balance-"
        balanceText.font = UIFont.preferredFont(forTextStyle: .caption1)
        balanceText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceText)
        
        let oweContainer = UIView()
        oweContainer.translatesAutoresizingMaskIntoConstraints = false
        oweContainer.backgroundColor = .lightGray
        view.addSubview(oweContainer)
        
        let infoButton = UIButton(type: .infoDark)
        infoButton.isEnabled = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        oweContainer.addSubview(infoButton)
        
        oweText.text = "You owe IDR xx to yy"
        oweText.translatesAutoresizingMaskIntoConstraints = false
        oweContainer.addSubview(oweText)
        
        paymentInfo.text = "Payment Information"
        paymentInfo.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentInfo)
        
        paymentDetail.text = "bank - nama - no rek"
        paymentDetail.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(paymentDetail)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            firstText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            firstText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 8),
            secondText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            balanceText.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 8),
            balanceText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            oweContainer.topAnchor.constraint(equalTo: balanceText.bottomAnchor, constant: 8),
            oweContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            oweContainer.widthAnchor.constraint(equalToConstant: 370),
            oweContainer.heightAnchor.constraint(equalToConstant: 36),
            
            infoButton.topAnchor.constraint(equalTo: oweContainer.topAnchor, constant: 8),
            infoButton.leadingAnchor.constraint(equalTo: oweContainer.leadingAnchor, constant: 8),
            infoButton.bottomAnchor.constraint(equalTo: oweContainer.bottomAnchor, constant: -8),
            infoButton.widthAnchor.constraint(equalTo: infoButton.heightAnchor),
            
            oweText.topAnchor.constraint(equalTo: oweContainer.topAnchor, constant: 8),
            oweText.leadingAnchor.constraint(equalTo: infoButton.trailingAnchor, constant: 8),
            oweText.trailingAnchor.constraint(equalTo: oweContainer.trailingAnchor, constant: -8),
            oweText.bottomAnchor.constraint(equalTo: oweContainer.bottomAnchor, constant: -8),
            
            
            
        ])
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 115),
            backgroundView.widthAnchor.constraint(equalToConstant: 370),
            backgroundView.heightAnchor.constraint(equalToConstant: 524)
        ])
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .lightGray
        scrollView.layer.cornerRadius = 10
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        backgroundView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -287)
        ])
    }
    
    private func setupButtons() {
        
        let shareLink = UIButton(type: .system)
        shareLink.setTitle("Confirm Your Payment", for: .normal)
        shareLink.setTitleColor(.white, for: .normal)
        shareLink.addTarget(self, action: #selector(confirmPaymentButtonTapped), for: .touchUpInside)
        shareLink.backgroundColor = Colors.greenCustom
        shareLink.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(shareLink)
        
        NSLayoutConstraint.activate([
            shareLink.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16),
            shareLink.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            shareLink.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            shareLink.heightAnchor.constraint(equalToConstant: 39),
            
            paymentDetail.bottomAnchor.constraint(equalTo: shareLink.topAnchor, constant: -16),
            paymentDetail.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            paymentDetail.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            paymentDetail.heightAnchor.constraint(equalToConstant: 39),
            
            paymentInfo.bottomAnchor.constraint(equalTo: paymentDetail.topAnchor, constant: -16),
            paymentInfo.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            paymentInfo.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
            paymentInfo.heightAnchor.constraint(equalToConstant: 39),
            
        ])
    }
    
    private func displayUser() {
        var lastView: UIView? = nil
        
        for user in displayedUser {
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.backgroundColor = .brown
            scrollView.addSubview(containerView)
            
            let nameLabel = UILabel()
            nameLabel.text = "\(user.personName)'s total"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(nameLabel)
            
            let phoneNumberLabel = UILabel()
            phoneNumberLabel.text = "\(user.personPhoneNumber)"
            phoneNumberLabel.font = UIFont.boldSystemFont(ofSize: 9)
            phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(phoneNumberLabel)
            
            
            
            NSLayoutConstraint.activate([
                containerView.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? scrollView.topAnchor, constant: 16),
                containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                containerView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
                //containerView.widthAnchor.constraint(equalToConstant: <#T##CGFloat#>)
                
                nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                
                phoneNumberLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
                phoneNumberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                phoneNumberLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                //                statusButton.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 0),
            ])
            
            lastView = containerView
            
            let divider = UIView()
            divider.backgroundColor = .gray
            divider.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(divider)
            
            NSLayoutConstraint.activate([
                divider.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
                divider.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                divider.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
                divider.heightAnchor.constraint(equalToConstant: 1),
            ])
            
            lastView = divider
            
            for item in user.items {
                let itemLabel = UILabel()
                itemLabel.text = "\(item.name) + \(item.quantity) + \(item.price)"
                itemLabel.font = UIFont.systemFont(ofSize: 16)
                itemLabel.translatesAutoresizingMaskIntoConstraints = false
                scrollView.addSubview(itemLabel)
                
                NSLayoutConstraint.activate([
                    itemLabel.topAnchor.constraint(equalTo: lastView!.bottomAnchor, constant: 8),
                    itemLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 32),
                    itemLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16)
                ])
                
                lastView = itemLabel
            }
        }
        
        if let lastView = lastView {
            lastView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16).isActive = true
        }
        
        // Adjust scrollView content size
        scrollView.layoutIfNeeded()
        //        scrollView.contentSize = CGSize(width: backgroundView.bounds.width, height: backgroundView.bounds.height)
    }
    
    // MARK: - Button Actions
    
    private func didFinishEnteringPaymentInfo(paymentMethod: String, accountName: String, accountNumber: String) {
        print("did finish entering payment info VVVV")
        paymentDetail.text = "\(paymentMethod) - \(accountName) - \(accountNumber)"
    }
    
    @objc private func confirmPaymentButtonTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        
        // Add a toolbar with a 'Done' button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexibleSpace, doneButton]
        
        imagePickerController.view.addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.bottomAnchor.constraint(equalTo: imagePickerController.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolbar.leadingAnchor.constraint(equalTo: imagePickerController.view.leadingAnchor).isActive = true
        toolbar.trailingAnchor.constraint(equalTo: imagePickerController.view.trailingAnchor).isActive = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped() {
        guard let picker = presentedViewController as? UIImagePickerController else { return }
        
        if let selectedImage = self.selectedImage {
            let alertController = UIAlertController(title: "Confirm", message: "Do you want to use this image?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                // Handle the confirmation
                picker.dismiss(animated: true, completion: {
                    let successAlert = UIAlertController(title: "Success", message: "Image selected successfully!", preferredStyle: .alert)
                    successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(successAlert, animated: true, completion: nil)
                })
            }))
            picker.present(alertController, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerControllerDelegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage = selectedImage
            // Optionally display the selected image in an image view
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
