//
//  ProfileViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 02/04/24.
//

import Foundation
import FirebaseAuth

class ProfileViewModel {
    func logoutUser(completion: @escaping (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            completion(false)
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
