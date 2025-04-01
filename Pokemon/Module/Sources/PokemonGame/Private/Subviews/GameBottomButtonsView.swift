import SwiftUI
import Designs

struct GameBottomButtonsView: View {
    var nextAction: (() -> Void)?
    var resetAction: (() -> Void)?
    
    var body: some View {
        HStack (spacing: 30) {
            GameButtonsView(title: "Next", action: {
                nextAction?()
            })
            GameButtonsView(title: "Reset", action: {
                resetAction?()
            })
        }
    }
}

// MARK: GameButtonsView
struct GameButtonsView: View {
    var title: String
    var action: () -> Void
    var optionSelected: Bool? = true
    var body: some View {
        Button(action: {
            action()
        }) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(Color.red)
                .foregroundStyle(.white)
                .font(Typography.title.font)
            
        }
        .frame(width: 150, height: 60)
        .cornerRadius(10)
        .disabled(!(optionSelected ?? false))
        .opacity((optionSelected ?? false) ? 1 : 0.5)
    }
}
