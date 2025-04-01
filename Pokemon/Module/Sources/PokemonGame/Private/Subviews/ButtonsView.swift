import SwiftUI

struct ButtonsView: View {
    @Binding var optionSelected: Bool
    var option1: String
    var option2: String
    var option3: String
    var option4: String
    
    var action: ((String) -> Void)
    var reloadAction: (() -> Void)
    var resetAction: (() -> Void)
    
    var body: some View {
        VStack (spacing: 10) {
            HStack (spacing: 30) {
                OptionsButtonView(title: option1, action: {
                    action(option1)
                    
                }, optionSelected: optionSelected)
                OptionsButtonView(title: option2, action: {
                    action(option1)
                }, optionSelected: optionSelected)
            }
            HStack (spacing: 30) {
                OptionsButtonView(title: option3, action: {
                    action(option1)
                }, optionSelected: optionSelected)
                OptionsButtonView(title: option4, action: {
                    action(option1)
                }, optionSelected: optionSelected)
            }
            
            GameBottomButtonsView(nextAction: {
                reloadAction()
            }, resetAction: {
                resetAction()
            })
            .opacity(optionSelected ? 1 : 0.4)
            .disabled(!optionSelected)
        }
    }
}
