import SwiftUI

struct Bar: Identifiable {
    let id = UUID()
    let value: Double
    let color: Color
    let label: String

    init(value: Double, color: Color, label: String) {
        self.value = value
        self.color = color
        self.label = label
    }
}
