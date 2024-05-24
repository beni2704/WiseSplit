import SwiftUI
import Combine

struct BarChart: View {
    @ObservedObject var viewModel: BarChartViewModel
    @State private var selectedMonth = 0
    
    var user: UserTemp
    
    var body: some View {
        VStack {
            MonthWheelPicker(selectedMonth: $selectedMonth)
                .frame(width: 150)
                .clipped()
            
            HStack {
                ForEach(viewModel.bars, id: \.label) { bar in
                    BarView(value: bar.value, color: bar.color, label: bar.label)
                }
            }
            .padding()
        }
        .onChange(of: selectedMonth) { newIndex in
            viewModel.updateBars(for: newIndex, user: user)
        }
    }
}
