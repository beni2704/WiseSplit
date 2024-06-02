//
//  FormatDateHour.swift
//  WiseSplit
//
//  Created by beni garcia on 02/06/24.
//

import Foundation

func formatDateHour(_ timestamp: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    guard let date = inputFormatter.date(from: timestamp) else {
        return "Invalid date format"
    }
     
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "d MMMM yyyy HH:mm"
    outputFormatter.locale = Locale(identifier: "en_US_POSIX")
    
    let formattedDateString = outputFormatter.string(from: date)
    return formattedDateString
}
