import SwiftUI

struct UserTemp {
    let name: String
    var assignedItems: [String] = []
    var total: Int
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
