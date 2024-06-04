//
//  AddPaymentInfoViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 04/06/24.
//

import Foundation
import FirebaseFirestore

class AddPaymentInfoViewModel {
    func savePaymentInfo(splitBillId: String, paymentInfo: PaymentInfo, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let paymentInfoData: [String: Any] = [
            "paymentMethod": paymentInfo.paymentMethod,
            "accountName": paymentInfo.accountName,
            "accountNumber": paymentInfo.accountNumber
        ]
        
        let documentRef = db.collection("splitBills").document(splitBillId)
        
        documentRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let document = document, document.exists {
                documentRef.updateData(["paymentInfo": paymentInfoData]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                documentRef.setData(["paymentInfo": paymentInfoData]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }
    
    func checkEmpty(paymentMethod: String, accountName: String, accountNumber: String) -> Bool {
        return paymentMethod == "" || accountName == "" || accountNumber == ""
    }
}
