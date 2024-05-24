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
    func loginUser(email: String, password: String, completion: @escaping (Result<Account, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                let account = Account(nickname: user.displayName ?? "", email: user.email ?? "", budget: 0)
                completion(.success(account))
            }
        }
    }
    
    func sendSignInLink(to email: String, completion: @escaping (Error?) -> Void) {
        let settings = ActionCodeSettings()
        settings.handleCodeInApp = true
        settings.url = URL(string: "https://wisesplit.page.link/otp")
        settings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        
        Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: settings) { error in
            if let error = error {
                completion(error)
            } else {
                UserDefaults.standard.set(email, forKey: "Email")
                completion(nil)
            }
        }
    }
    
    func handleSignInLink(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let email = UserDefaults.standard.string(forKey: "Email"),
              let link = UserDefaults.standard.string(forKey: "Link") else {
            completion(.failure(NSError(domain: "Email or link not found", code: 0, userInfo: nil)))
            return
        }
        
        if Auth.auth().isSignIn(withEmailLink: link) {
            Auth.auth().signIn(withEmail: email, link: link) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } else {
            completion(.failure(NSError(domain: "Invalid link", code: 0, userInfo: nil)))
        }
    }
    
    func checkEmailExists(email: String, completion: @escaping (Bool) -> Void) {
        let normalizedEmail = email.lowercased()
        let db = Firestore.firestore()
        db.collection("users").whereField("email", isEqualTo: normalizedEmail).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching documents: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(!snapshot!.documents.isEmpty)
        }
    }
    
    
}
