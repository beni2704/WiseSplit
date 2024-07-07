//
//  RegisterViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RegisterViewModel {
    public func checkPhoneExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
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

    public func registerUserIfNotExists(account: Account, completion: @escaping (Bool) -> Void) {
        checkPhoneExists(phoneNumber: account.phone) { exists in
            if exists {
                completion(false)
            } else {
                self.sendVerificationCode(phoneNumber: account.phone)
                completion(true)
            }
        }
    }
    
    public func validateNickname(_ nickname: String) -> Bool{
        let length = nickname.count
        guard length >= 4 && length <= 12 else {
            return false
        }
        return true
    }
    
    public func validatePhone(_ phoneNumber: String) -> Bool {
        guard phoneNumber.hasPrefix("+628") else {
            return false
        }
        
        let length = phoneNumber.count
        guard length >= 12 && length <= 15 else {
            return false
        }
        
        let numericPart = phoneNumber.dropFirst(4)
        let isNumeric = numericPart.allSatisfy { $0.isNumber }
        
        return isNumeric
    }
    
    public func sendVerificationCode(phoneNumber: String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
        }
    }
}

