import SwiftUI

struct MonthWheelPicker: View {
    @Binding var selectedMonth: Int
    
    let months = Calendar.current.monthSymbols
    
    var body: some View {
        Picker(selection: $selectedMonth, label: Text("Month")) {
            ForEach(0 ..< months.count, id: \.self) { index in
                Text(self.months[index]).tag(index)
            }
        }
        .pickerStyle(WheelPickerStyle())
    }
}
