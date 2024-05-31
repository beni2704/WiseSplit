//
//  SplitBillStore.swift
//  WiseSplit
//
//  Created by beni garcia on 28/05/24.
//

import Foundation
import FirebaseFirestore

class SplitBillStore {
    func saveSplitBill(splitBill: SplitBill, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let image = splitBill.image else {
           let error = NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image is nil"])
           completion(.failure(error))
           return
       }
        
        uploadImage(image: image) { result in
            switch result {
            case .success(let imageUrl):
                let splitBillData = splitBill.toDictionary(imageUrl: imageUrl)
                let db = Firestore.firestore()
                db.collection("splitBills").addDocument(data: splitBillData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updatePaymentStatus(splitBillId: String, personUUID: String, isPaid: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let splitBillRef = db.collection("splitBills").document(splitBillId)
        
        splitBillRef.getDocument { document, error in
            if let document = document, document.exists {
                var splitBillData = document.data() ?? [:]
                var personTotals = splitBillData["personTotals"] as? [[String: Any]] ?? []
                
                for i in 0..<personTotals.count {
                    if personTotals[i]["personUUID"] as? String == personUUID {
                        personTotals[i]["isPaid"] = isPaid
                    }
                }
                
                splitBillData["personTotals"] = personTotals
                splitBillRef.setData(splitBillData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                completion(.failure(error ?? NSError(domain: "DocumentError", code: -1, userInfo: nil)))
            }
        }
    }
    
    func fetchSplitBillDetail(splitBillId: String, completion: @escaping (Result<SplitBill?, Error>) -> Void) {
        let db = Firestore.firestore()
        let splitBillRef = db.collection("splitBills").document(splitBillId)
        
        splitBillRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                completion(.failure(NSError(domain: "DocumentError", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let splitBill = try self.parseSplitBill(from: document.data())
                // Safely unwrap splitBill and its image before using
                if var splitBill = splitBill {
                    downloadImage(for: splitBill.imageUrl) { result in
                        switch result {
                        case .success(let image):
                            splitBill.image = image
                            completion(.success(splitBill))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    }
                } else {
                    completion(.failure(NSError(domain: "ImageError", code: -1, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }

    
    private func parseSplitBill(from data: [String: Any]?) throws -> SplitBill? {
        guard let data = data else { return nil }
        
        guard let title = data["title"] as? String,
              let dateString = data["date"] as? String,
              let total = data["total"] as? Int,
              let imageUrl = data["imageUrl"] as? String,
              let personTotalsData = data["personTotals"] as? [[String: Any]] else {
            throw NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
        }
        
        guard let date = DateFormatter.iso8601DateFormatter.date(from: dateString) else {
            throw NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid date format"])
        }
        
        let personTotals: [PersonTotal] = try personTotalsData.map { personTotalData in
            guard let personUUID = personTotalData["personUUID"] as? String,
                  let personName = personTotalData["personName"] as? String,
                  let personPhoneNumber = personTotalData["personPhoneNumber"] as? String,
                  let totalAmount = personTotalData["totalAmount"] as? Int,
                  let isPaid = personTotalData["isPaid"] as? Bool,
                  let itemsData = personTotalData["items"] as? [[String: Any]] else {
                throw NSError(domain: "ParsingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid person total data format"])
            }
            
            let items: [BillItem] = itemsData.compactMap { itemData in
                guard let name = itemData["name"] as? String,
                      let quantity = itemData["quantity"] as? Int,
                      let price = itemData["price"] as? Int else {
                    return nil
                }
                return BillItem(name: name, quantity: quantity, price: price)
            }
            
            return PersonTotal(personUUID: personUUID, personName: personName, personPhoneNumber: personPhoneNumber, totalAmount: totalAmount, items: items, isPaid: isPaid)
        }
        
        return SplitBill(title: title, date: date, total: total, imageUrl: imageUrl, personTotals: personTotals)
    }
}
