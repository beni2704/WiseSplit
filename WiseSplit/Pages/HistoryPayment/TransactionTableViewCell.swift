//
//  TransactionTableViewCell.swift
//  WiseSplit
//
//  Created by beni garcia on 03/05/24.
//

import Foundation
import UIKit

class TransactionTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TransactionTableViewCell"
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .grayCustom
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(iconImageView)
        addSubview(categoryLabel)
        addSubview(amountLabel)
        addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            
            categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            categoryLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            amountLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            amountLabel.trailingAnchor.constraint(equalTo: categoryLabel.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with transaction: TransactionUser) {
        categoryLabel.text = transaction.category
        amountLabel.text = "\(formatToIDR(transaction.amount))"
        amountLabel.textColor = .redCustom
        dateLabel.text = "\(formatDateHour(transaction.date.description))"
        
        switch transaction.category {
        case "Food & Beverage":
            iconImageView.image = UIImage(systemName: "fork.knife")
        case "Health Care":
            iconImageView.image = UIImage(systemName: "stethoscope")
        case "Transportation":
            iconImageView.image = UIImage(systemName: "bus")
        case "Entertainment":
            iconImageView.image = UIImage(systemName: "guitars")
        case "Split Bill Received":
            iconImageView.image = UIImage(systemName: "newspaper")
            amountLabel.textColor = .greenCustom
        case "Income":
            iconImageView.image = UIImage(systemName: "dollarsign")
            amountLabel.textColor = .greenCustom
        default:
            iconImageView.image = UIImage(systemName: "newspaper")
        }
    }
}
