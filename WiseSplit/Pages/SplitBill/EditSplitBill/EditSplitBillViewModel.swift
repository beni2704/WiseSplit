//
//  EditSplitBillViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 30/05/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class EditSplitBillViewModel {
    let db = Firestore.firestore()
    
    func currUserId() -> String {
        return Auth.auth().currentUser?.uid ?? "nil"
    }
    
    func fetchLoginAccount(completion: @escaping (Result<PersonTotal, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])))
            return
        }
        
        let uid = user.uid
        
        db.collection("users").document(uid).getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                completion(.failure(NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User data not found."])))
                return
            }
            
            guard let nickname = data["nickname"] as? String,
                  let phone = data["phone"] as? String else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user data format."])))
                return
            }
            
            let personTotal = PersonTotal(
                personUUID: uid,
                personName: nickname,
                personPhoneNumber: phone,
                totalAmount: 0,
                items: [],
                isPaid: true,
                imagePaidUrl: "Owner"
            )
            
            completion(.success(personTotal))
        }
    }
    
    func checkAmountUser(splitBill: SplitBill, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists {
                let data = document.data()
                var currentBudget = data?["budget"] as? Int ?? 0
                let amount = splitBill.personTotals.first{$0.personUUID == userId}?.totalAmount ?? 0
                
                if amount > currentBudget {
                    completion(.success(false))
                    return
                }
                currentBudget -= amount
                
                userRef.updateData(["budget": currentBudget]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    func saveSplitBill(splitBill: SplitBill, completion: @escaping (Result<String, Error>) -> Void) {
        guard let image = splitBill.image else {
            let error = NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Image is nil"])
            completion(.failure(error))
            return
        }
        
        guard let compressedImageData = compressImage(image) else {
            let error = NSError(domain: "CompressionError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to compress image"])
            completion(.failure(error))
            return
        }
        
        uploadImage(path: "splitbill/bill/", image: UIImage(data: compressedImageData)!) { result in
            switch result {
            case .success(let imageUrl):
                let splitBillData = splitBill.toDictionary(imageUrl: imageUrl)
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
                ref = db.collection("splitBills").addDocument(data: splitBillData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        if let documentID = ref?.documentID {
                            self.saveTransactionForUsers(splitBillUID: documentID, splitBill: splitBill) { [weak self] res in
                                switch res {
                                case .success(_):
                                    completion(.success(documentID))
                                case .failure(let error):
                                    completion(.failure(error.localizedDescription as! Error))
                                }
                            }
                        } else {
                            let error = NSError(domain: "FirestoreError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve document ID"])
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func saveTransactionForUsers(splitBillUID: String, splitBill: SplitBill, completion: @escaping (Result<String, Error>) -> Void) {
        let batch = db.batch()
        
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])))
            return
        }
        
        for personTotal in splitBill.personTotals {
            let transactionData: [String: Any] = [
                "amount": personTotal.totalAmount,
                "category": personTotal.personUUID == user.uid ? "Split Bill Received" : "Split Bill Owe",
                "date": Date(),
                "splitBillUID": splitBillUID
            ]
            
            let userRef = db.collection("users").document(personTotal.personUUID)
            let transactionRef = userRef.collection("transactions").document()
            batch.setData(transactionData, forDocument: transactionRef)
        }
        
        batch.commit { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success("Transactions saved successfully"))
            }
        }
    }
}
