import UIKit

class ResultViewModel {
    
    var displayedUsers: [UserTemp]
    var billName: String
    
    init(displayedUsers: [UserTemp], billName: String) {
        self.displayedUsers = displayedUsers
        self.billName = billName
    }
    
    // MARK: - Labels and UI Elements
    
    var titleLabelText: String {
        return "Total Amount"
    }
    
    var firstLabelText: String {
        return billName
    }
    
    var secondLabelText: String {
        return "Bill Date"
    }
    
    // MARK: - UI Setup Methods
    
    func setupBackgroundView(_ backgroundView: UIView) {
        backgroundView.backgroundColor = .lightGray
        backgroundView.layer.cornerRadius = 10
    }
    
    func setupScrollView(_ scrollView: UIScrollView, in backgroundView: UIView) {
        scrollView.backgroundColor = .lightGray
        scrollView.layer.cornerRadius = 10
        scrollView.showsVerticalScrollIndicator = true // Enable vertical scroll indicator
        backgroundView.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -287)
        ])
    }
    
    // MARK: - Display Users
    
    func userNameText(for user: UserTemp) -> String {
        let formattedTotalOwe = String(format: "%.2f", user.totalOwe)
        return "\(user.name)'s total: \(formattedTotalOwe)"
    }
    
    func userPhoneNumberText(for user: UserTemp) -> String {
        return "\(user.phoneNumber)"
    }
    
    func userStatusButtonText(for user: UserTemp) -> String {
        return user.paidStatus ? "See Payment" : "Unpaid"
    }
    
    func userStatusButtonColor(for user: UserTemp) -> UIColor {
        return user.paidStatus ? .green : .gray
    }
    
    func userStatusButtonEnabled(for user: UserTemp) -> Bool {
        return user.paidStatus
    }
}
