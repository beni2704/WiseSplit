//
//  ResultSplitBillViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit
import FirebaseFirestore

class ResultViewModel {
    func fetchSplitBillDetail(splitBillId uid: String, completion: @escaping (Result<SplitBill?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("splitBills").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                if let splitBillData = document.data() {
                    var splitBill = self.parseSplitBill(from: splitBillData)
                    downloadImage(for: splitBill.imageUrl) { result in
                        switch result {
                        case .success(let image):
                            splitBill.image = image
                            completion(.success(splitBill))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                    completion(.success(splitBill))
                } else {
                    completion(.success(nil)) 
                }
            } else {
                completion(.success(nil))
            }
        }
    }

    func parseSplitBill(from data: [String: Any]) -> SplitBill {
        let title = data["title"] as? String ?? ""
        let date = data["date"] as? Date ?? Date()
        let total = data["total"] as? Int ?? 0
        let imageUrl = data["imageUrl"] as? String ?? ""
        let personTotalsData = data["personTotals"] as? [[String: Any]] ?? []
        let personTotals = personTotalsData.map { parsePersonTotal(from: $0) }
        
        return SplitBill(title: title, date: date, total: total, image: nil, imageUrl: imageUrl, personTotals: personTotals, paymentInfo: nil)
    }

    func parsePersonTotal(from data: [String: Any]) -> PersonTotal {
        let personUUID = data["personUUID"] as? String ?? ""
        let personName = data["personName"] as? String ?? ""
        let personPhoneNumber = data["personPhoneNumber"] as? String ?? ""
        let totalAmount = data["totalAmount"] as? Int ?? 0
        let itemsData = data["items"] as? [[String: Any]] ?? []
        let items = itemsData.map { parseBillItem(from: $0) }
        let isPaid = data["isPaid"] as? Bool ?? false
        let imagePaidUrl = data["imagePaidUrl"] as? String ?? ""
        
        return PersonTotal(personUUID: personUUID, personName: personName, personPhoneNumber: personPhoneNumber, totalAmount: totalAmount, items: items, isPaid: isPaid, imagePaid: nil, imagePaidUrl: imagePaidUrl)
    }

    func parseBillItem(from data: [String: Any]) -> BillItem {
        let name = data["name"] as? String ?? ""
        let quantity = data["quantity"] as? Int ?? 0
        let price = data["price"] as? Int ?? 0
        return BillItem(name: name, quantity: quantity, price: price)
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
}
