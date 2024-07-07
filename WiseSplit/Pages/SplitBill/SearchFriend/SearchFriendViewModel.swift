//
//  SearchFriendViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 17/05/24.
//

import Foundation
import FirebaseFirestore

class SearchFriendViewModel {
    var users: [Account] = []
    var filteredUsers: [Account] = []
    
    public func searchUsers(byNickname nickname: String, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        db.collection("users").whereField("nickname", isEqualTo: nickname).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            self.users = []
            
            if let error = error {
                print("Error searching users: \(error.localizedDescription)")
                completion()
                return
            }
            
            for document in snapshot!.documents {
                let data = document.data()
                if let nickname = data["nickname"] as? String,
                   let phone = data["phone"] as? String {
                    let user = Account(uuid: document.documentID, nickname: nickname, phone: phone)
                    self.users.append(user)
                }
            }
            self.users.append(Account(uuid: "0", nickname: nickname, phone: "Not Registered"))
            self.filteredUsers = self.users
            completion()
        }
    }
    
    public func filterUsers(searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.nickname.lowercased().contains(searchText.lowercased()) }
        }
    }
}

