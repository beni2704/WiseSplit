import UIKit

class ResultViewController: UIViewController {
    
    // MARK: - Properties
    
    var titleLabel = UILabel()
    var firstText = UILabel()
    var secondText = UILabel()
    
    var userLabel = UILabel()
    
    let backgroundView = UIView()
    let scrollView = UIScrollView()
    
    var displayedUser: [User] = []
    
    var itemYOffset: CGFloat = 40
    
    // MARK: - Initialization
    
    init(displayedUser: [User]) {
        self.displayedUser = displayedUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        view.backgroundColor = AppTheme.backgroundColor
        
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
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            firstText.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            firstText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 8),
            secondText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupBackgroundView() {
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 10
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50),
            backgroundView.widthAnchor.constraint(equalToConstant: 370),
            backgroundView.heightAnchor.constraint(equalToConstant: 524)
        ])
    }
    
    private func setupScrollView() {
        scrollView.backgroundColor = .blue
        scrollView.layer.cornerRadius = 10
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        backgroundView.addSubview(scrollView)
        
        userLabel.numberOfLines = 0 // Allows for multiple lines
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(userLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 200),
            
            userLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            userLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            userLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            userLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func setupButtons() {
        let addPaymentButton = UIButton(type: .system)
        addPaymentButton.setTitle("Add Payment", for: .normal)
        addPaymentButton.setTitleColor(AppTheme.textColor, for: .normal)
        addPaymentButton.backgroundColor = AppTheme.gray
        addPaymentButton.frame = CGRect(x: 50, y: itemYOffset, width: 342.28, height: 39)
        addPaymentButton.addTarget(self, action: #selector(addPaymentButtonTapped), for: .touchUpInside)
        //backgroundView.addSubview(addPaymentButton)
        
        let shareLink = UIButton(type: .system)
        shareLink.setTitle("Share Link", for: .normal)
        shareLink.setTitleColor(AppTheme.textColor, for: .normal)
        shareLink.backgroundColor = AppTheme.green
        shareLink.frame = CGRect(x: 240, y: itemYOffset, width: 342.28, height: 39)
        shareLink.addTarget(self, action: #selector(shareLinkButtonTapped), for: .touchUpInside)
        //backgroundView.addSubview(shareLink)
        
        NSLayoutConstraint.activate([
//            addPaymentButton.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 16),
//            addPaymentButton.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
//            addPaymentButton.trailingAnchor.constraint(equalTo: shareLink.leadingAnchor, constant: -16),
//            addPaymentButton.bottomAnchor.constraint(equalTo: shareLink.topAnchor, constant: -16),
//
//            shareLink.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16),
//            shareLink.heightAnchor.constraint(equalToConstant: 39),
//            shareLink.widthAnchor.constraint(equalToConstant: 100),
//            shareLink.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -16)
        ])
    }
    
    private func displayUser() {
        var displayedUserText = ""
        for user in displayedUser {
            displayedUserText += "\(user.name): \(user.assignedItems.joined(separator: ", "))\n"
        }
        userLabel.text = displayedUserText
    }
    
    // MARK: - Button Actions
    
    @objc private func addPaymentButtonTapped() {
        // Add payment logic
    }
    
    @objc private func shareLinkButtonTapped() {
        // Share link logic
    }
}
