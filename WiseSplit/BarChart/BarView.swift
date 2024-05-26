import SwiftUI

struct BarView: View {
    var value: CGFloat
    var color: Color
    var label: String
    
    var body: some View {
        VStack {
            Spacer()
            Rectangle()
                .fill(color)
                .frame(width: 50, height: value * 300)
            Text(label)
                .padding(.top, 8)
        }
    }
}

//#Preview {
//    BarView(value: 0.7, color: .red, label: "A")
//}
