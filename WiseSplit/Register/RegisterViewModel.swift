//
//  RegisterViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 11/03/24.
//

import Foundation

class RegisterViewModel {
    func registerAccount(nickname: String, phoneNumber: String ,password: String, confirmPassword: String) -> Int {
        if nickname.isEmpty || phoneNumber.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            return 2 //data kosong
        }
        if validateMobileNumber(phoneNumber) {
            return 3 //bukan no hp
        }
        if password != confirmPassword {
            return 4 //password beda
        }
        
        return 1
    }
    
    
    func validateMobileNumber(_ mobileNumber: String) -> Bool {
        let mobileNumberPattern = "^08[0-9]{9,12}$"
        
        guard let regex = try? NSRegularExpression(pattern: mobileNumberPattern) else {
            return false
        }
        
        let range = NSRange(location: 0, length: mobileNumber.utf16.count)
        return regex.firstMatch(in: mobileNumber, options: [], range: range) != nil
    }

}
