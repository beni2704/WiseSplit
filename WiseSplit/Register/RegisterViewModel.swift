//
//  RegisterViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import Foundation
import FirebaseAuth

class RegisterViewModel {
    func registerAccount(nickname: String, email: String, password: String, confirmPassword: String, completion: @escaping (Result<User, Error>) -> Void) {
        if !validateEmail(email) {
            completion(.failure(RegisterError.invalidEmail))
            return
        }
        
        if password != confirmPassword {
            completion(.failure(RegisterError.passwordMismatch))
            return
        }
        
        registerUser(withEmail: email, password: password, completion: completion)
    }
    
    
    func validateEmptyField(_ nickname: String, _ email: String, _ password: String, _ confirmPassword: String) -> Bool{
        return !nickname.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    func validatePassword(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    func registerUser(withEmail email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            }
        }
    }
}

