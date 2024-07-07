import SwiftUI
import Charts

struct BarChartsView: View {
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: String = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }()
    
    @ObservedObject var homeVM = HomeViewModel()
    
    init() {
        homeVM.fetchTransaction {
            return
        }
    }
    
    private var availableYears: [Int] {
        let years = homeVM.spentCategories.map { Calendar.current.component(.year, from: $0.date) }
        return Array(Set(years)).sorted()
    }
    
    private var availableMonths: [String] {
        var months = homeVM.spentCategories.map { Calendar.current.component(.month, from: $0.date) }
        months.append(Calendar.current.component(.month, from: Date()))
        let monthStrings = months.map { monthName(from: $0) }
        return Array(Set(monthStrings)).sorted(by: { monthNumber(from: $0) < monthNumber(from: $1) })
    }
    
    private var allCategories: [String] {
        let categories = homeVM.spentCategories.map { $0.category }
        return Array(Set(categories))
    }
    
    private var filteredCategories: [String] {
        let categories = homeVM.spentCategories
            .filter { category in
                let components = Calendar.current.dateComponents([.year, .month], from: category.date)
                return components.year == selectedYear && components.month == monthNumber(from: selectedMonth)
            }
            .map { $0.category }
        return Array(Set(categories))
    }
    
    private var filteredSpentCategory: [TransactionUser] {
        return homeVM.spentCategories.filter { category in
            let components = Calendar.current.dateComponents([.year, .month], from: category.date)
            return components.year == selectedYear && components.month == monthNumber(from: selectedMonth)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Total Saving")
                    Text("Rp. \(filteredSpentCategory.filter { $0.category == "Income" }.reduce(0, { $0 + $1.amount }))")
                        .foregroundColor(.green)
                        .fontWeight(.bold)

                    Text("Total Spending")
                    Text("Rp. \(filteredSpentCategory.filter { $0.category != "Income" }.reduce(0, { $0 + $1.amount }))")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                    
                    Text("\(selectedMonth) \(String(selectedYear))")
                }
                Spacer()
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(.green)
                        Text("Income")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(.gray)
                        Text("Spending")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(.red)
                        Text("Owe")
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Image(systemName: "line.diagonal")
                            .rotationEffect(Angle(degrees: 45))
                            .foregroundColor(.yellow)
                        Text("Health Care")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.bottom, 12)
            
            HStack {
                Spacer()
                Picker("Select Month", selection: $selectedMonth) {
                    ForEach(availableMonths, id: \.self) { month in
                        Text(String(month)).tag(month)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                Spacer()
                
                Picker("Select Year", selection: $selectedYear) {
                    ForEach(availableYears, id: \.self) { year in
                        Text(String(year)).tag(year)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                
                Spacer()
            }
            
            if filteredSpentCategory.isEmpty {
                Text("No data")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, maxHeight: 180, alignment: .center)
            } else {
                Chart {
                    ForEach(["Income", "Spending", "Owe", "Health Care"], id: \.self) { category in
                        let categoryData = filteredSpentCategory.filter { $0.category == category }
                        let totalSpent = categoryData.reduce(0) { $0 + $1.amount }
                        
                        BarMark(x: .value("Category", category), y: .value("Spent", totalSpent))
                            .foregroundStyle(color(for: category))
                            .cornerRadius(12)
                    }
                }
            }
        }
        .padding(12)
        .background(Color(uiColor: Colors.backgroundChartCustom!))
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 3)
        
    }
    
    private func color(for category: String) -> Color {
        switch category {
        case "Income":
            return .green
        case "Spending":
            return .gray
        case "Owe":
            return .red
        case "Health Care":
            return .yellow
        default:
            return .blue
        }
    }
    
    private func monthNumber(from monthName: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        if let date = formatter.date(from: monthName) {
            return Calendar.current.component(.month, from: date)
        }
        return 1
    }
    
    private func monthName(from monthNumber: Int) -> String {
        let formatter = DateFormatter()
        let monthSymbols = formatter.monthSymbols
        return monthSymbols?[monthNumber - 1] ?? "January"
    }
}

#Preview {
    BarChartsView()
}
