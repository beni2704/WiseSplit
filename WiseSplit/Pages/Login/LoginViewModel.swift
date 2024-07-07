//
//  LoginViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 22/03/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel {
    public func sendVerificationCode(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            // Store verificationID securely for later use
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
    
    public func checkPhoneNumberExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("phone", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(!snapshot!.documents.isEmpty)
        }
    }
}
