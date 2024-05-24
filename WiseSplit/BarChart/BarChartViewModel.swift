import SwiftUI

class BarChartViewModel: ObservableObject {
    @Published var bars: [Bar] = []
    
    init() {}
    
    func updateBars(for monthIndex: Int, user: UserTemp) {
        guard monthIndex >= 0 && monthIndex < user.yearlyData[0].monthData.count else {
            return
        }
        
        let monthData = user.yearlyData[0].monthData[monthIndex]
        
        bars = [
            Bar(value: monthData.val1, color: .gray, label: "Spending"),
            Bar(value: monthData.val2, color: .red, label: "Owe"),
            Bar(value: monthData.val3, color: .green, label: "Health Care")
        ]
    }
}
