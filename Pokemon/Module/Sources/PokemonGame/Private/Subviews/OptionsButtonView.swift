import SwiftUI
import Designs

struct OptionsButtonView: View {
    let title: String?
    let action: () -> Void
    let optionSelected: Bool
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title ?? "")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(.yellow)
                .foregroundStyle(.blue)
                .font(Typography.title.font)
        }
        .disabled(optionSelected)
        .frame(width: 150, height: 60)
        .cornerRadius(10)
        .opacity(optionSelected ? 0.5 : 1)
    }
}
