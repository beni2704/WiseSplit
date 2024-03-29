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
    func registerAccount(nickname: String, email: String, password: String, confirmPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
        if !validateEmptyField(nickname, email, password, confirmPassword) {
            completion(.failure(RegisterError.invalidTextField))
            return
        }
        if !validateEmail(email) {
            completion(.failure(RegisterError.invalidEmail))
            return
        }
        
        if !validatePassword(password: password, confirmPassword: confirmPassword) {
            completion(.failure(RegisterError.passwordMismatch))
            return
        }
        let account = Account(nickname: nickname, email: email)
        
        registerUser(withAccount: account, password: password, completion: completion)
    }
    
    
    func validateEmptyField(_ nickname: String, _ email: String, _ password: String, _ confirmPassword: String) -> Bool{
        return !nickname.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword(password: String, confirmPassword: String) -> Bool {
        var validateUpper = false
        if password.count < 6 {
            return true
        }
        
        for char in password {
            if char.isUppercase && char.isLetter {
                validateUpper = true
                break
            }
        }
        
        if password != confirmPassword {
            return true
        }
        
        if validateUpper {
            return true
        }
        
        return false
    }
    
    func registerUser(withAccount account: Account, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: account.email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                
                let userData: [String: Any] = [
                    "nickname": account.nickname,
                    "email": account.email
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

