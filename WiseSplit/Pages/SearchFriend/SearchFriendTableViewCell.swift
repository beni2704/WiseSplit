//
//  SearchFriendTableViewCell.swift
//  WiseSplit
//
//  Created by beni garcia on 17/05/24.
//

import Foundation
import UIKit

class SearchFriendTableViewCell: UITableViewCell {
    static let identifier = "UserTableViewCell"
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(emailLabel)
        contentView.addSubview(nicknameLabel)
        
        NSLayoutConstraint.activate([
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nicknameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            nicknameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: Account) {
        nicknameLabel.text = user.nickname
        emailLabel.text = user.phone
    }
}
