//
//  LoginViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 22/03/24.
//

import Foundation
import FirebaseAuth

class LoginViewModel {
    func loginUser(email: String, password: String, completion: @escaping (Result<Account, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                let account = Account(nickname: user.displayName ?? "", email: user.email ?? "")
                completion(.success(account))
            }
        }
    }
}
