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
    
    func fetchLoginAccount(completion: @escaping (Result<PersonTotal, Error>) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is currently logged in."])))
            return
        }
        
        let uid = user.uid
        let db = Firestore.firestore()
        
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
                isPaid: false
            )
            
            completion(.success(personTotal))
        }
    }
    
}
