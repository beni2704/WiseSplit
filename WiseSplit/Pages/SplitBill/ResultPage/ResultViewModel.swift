//
//  ResultSplitBillViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseAuth

class ResultViewModel {
    func isOwner(splitBillOwnerId: String) -> Bool {
        return Auth.auth().currentUser?.uid == splitBillOwnerId
    }
    
    func updatePaymentStatus(image: UIImage, splitBillDetailId: String,completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let splitBillRef = db.collection("splitBills").document(splitBillDetailId)
        let userId = Auth.auth().currentUser?.uid
        
        guard let compressedImageData = compressImage(image) else {
            let error = NSError(domain: "CompressionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])
            completion(.failure(error))
            return
        }
        
        uploadImage(path: "splitbill/payment/", image: UIImage(data: compressedImageData)!) { result in
            switch result {
            case.success(let imageUrl):
                splitBillRef.getDocument { document, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let document = document, document.exists, var splitBillData = document.data() {
                        var personTotals = splitBillData["personTotals"] as? [[String: Any]] ?? []
                        if let index = personTotals.firstIndex(where: { $0["personUUID"] as? String == userId }) {
                            personTotals[index]["isPaid"] = true
                            personTotals[index]["imagePaidUrl"] = imageUrl
                            splitBillData["personTotals"] = personTotals
                            splitBillRef.setData(splitBillData) { error in
                                if let error = error {
                                    completion(.failure(error))
                                } else {
                                    completion(.success(()))
                                }
                            }
                        } else {
                            completion(.failure(NSError(domain: "UserNotFoundError", code: -1, userInfo: nil)))
                        }
                    } else {
                        completion(.failure(NSError(domain: "DocumentNotFoundError", code: -1, userInfo: nil)))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSplitBillDetail(splitBillId uid: String, completion: @escaping (Result<SplitBill?, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("splitBills").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let splitBillData = document.data() else {
                completion(.success(nil))
                return
            }
            
            var splitBill = self.parseSplitBill(from: splitBillData)
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            downloadImage(for: splitBill.imageUrl) { result in
                defer { dispatchGroup.leave() }
                switch result {
                case .success(let image):
                    splitBill.image = image
                    for i in 0..<splitBill.personTotals.count {
                        if splitBill.personTotals[i].imagePaidUrl == "Owner" {
                            splitBill.personTotals[i].imagePaid = splitBill.image
                            continue
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                    return
                }
            }
            
            for i in 0..<splitBill.personTotals.count {
                if splitBill.personTotals[i].imagePaidUrl == "Owner" {
                    splitBill.personTotals[i].imagePaid = splitBill.image
                    continue
                }
                if splitBill.personTotals[i].imagePaidUrl.hasPrefix("gs://") || splitBill.personTotals[i].imagePaidUrl.hasPrefix("http://") || splitBill.personTotals[i].imagePaidUrl.hasPrefix("https://") {
                    dispatchGroup.enter()
                    downloadImage(for: splitBill.personTotals[i].imagePaidUrl) { result in
                        defer { dispatchGroup.leave() }
                        switch result {
                        case .success(let image):
                            splitBill.personTotals[i].imagePaid = image
                        case .failure(let error):
                            completion(.failure(error))
                            return
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(.success(splitBill))
            }
        }
    }
    
    func parseSplitBill(from data: [String: Any]) -> SplitBill {
        let title = data["title"] as? String ?? ""
        let date = data["date"] as? Date ?? Date()
        let total = data["total"] as? Int ?? 0
        let imageUrl = data["imageUrl"] as? String ?? ""
        let personTotalsData = data["personTotals"] as? [[String: Any]] ?? []
        let ownerId = data["ownerId"] as? String ?? ""
        let personTotals = personTotalsData.map { parsePersonTotal(from: $0) }
        let paymentInfoData = data["paymentInfo"] as? [String: Any]
        
        let paymentInfo = paymentInfoData != nil ? parsePaymentInfo(from: paymentInfoData!) : nil
        
        
        return SplitBill(title: title, date: date, total: total, image: nil, imageUrl: imageUrl, personTotals: personTotals, ownerId: ownerId, paymentInfo: paymentInfo)
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
    
    func parsePaymentInfo(from data: [String: Any]) -> PaymentInfo {
        let accName = data["accountName"] as? String ?? ""
        let accNumber = data["accountNumber"] as?  String ?? ""
        let accMethod = data["paymentMethod"] as?  String ?? ""
        return PaymentInfo(paymentMethod: accMethod, accountName: accName, accountNumber: accNumber)
    }
}
