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
