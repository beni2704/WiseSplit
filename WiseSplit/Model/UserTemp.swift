import SwiftUI

struct UserTemp {
    let name: String
    let phoneNumber: String
    var assignedItems: [String] = []
    var totalOwe: Double
    var currentBalance: Int
    var paidStatus: Bool
    var yearlyData: [YearlyData]
}



struct YearlyData {
    var monthData: [MonthData]
}

struct MonthData {
    var val1: Double
    var val2: Double
    var val3: Double
}
