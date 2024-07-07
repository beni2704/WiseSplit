//
//  OTPViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 24/05/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class OTPViewModel {
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
    
    public func signInWithVerificationCode(verificationCode: String, withAccount account: Account, completion: @escaping (Result<User, Error>) -> Void) {
        guard let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") else {
            completion(.failure(NSError(domain: "VerificationIDNotFound", code: 0, userInfo: [NSLocalizedDescriptionKey: "Verification ID not found."])))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
        
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                completion(.failure(error))
                print("Error: \(error.localizedDescription)")
                return
            } else if let user = authResult?.user {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                
                userRef.getDocument { (document, error) in
                    if let error = error {
                        completion(.failure(error))
                        print("Error fetching user document: \(error.localizedDescription)")
                        return
                    }
                    
                    if let document = document, document.exists {
                        completion(.success(user))
                        print("User already exists in Firestore")
                    } else {
                        let userData: [String: Any] = [
                            "nickname": account.nickname,
                            "phone": account.phone,
                            "budget": 0
                        ]
                        
                        userRef.setData(userData) { error in
                            if let error = error {
                                completion(.failure(error))
                            } else {
                                completion(.success(user))
                            }
                        }
                    }
                }
            }
        }
    }
}

