//
//  ContentView.swift
//  Pokemon
//
//  Created by Manjinder Singh on 29/03/2025.
//

import SwiftUI
import Branding

// MARK: ContentView
struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var optionSelected: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                TopView(optionSelected: $optionSelected,
                        score: viewModel.score,
                        url: viewModel.game?.currentPokemon.url,
                        name: viewModel.game?.currentPokemon.name)
                .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                .background(Color.blue)
                
                ButtonsView(optionSelected: $optionSelected,
                            option1: viewModel.game?.option1 ?? "",
                            option2: viewModel.game?.option2 ?? "",
                            option3: viewModel.game?.option3 ?? "",
                            option4: viewModel.game?.option4 ?? "") { selectedOption in
                    viewModel.result(with: selectedOption)
                    optionSelected = true
                } reloadAction: {
                    optionSelected = false
                    Task {
                        try? await viewModel.loadRound()
                    }
                } resetAction: {
                    optionSelected = false
                    viewModel.reset()
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                .background(.gray)
            }
        }
    }
}

// MARK: TopView
struct TopView: View {
    @Binding var optionSelected: Bool
    var score: Int
    var url: URL?
    let name: String?
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .padding(.bottom, 60)
                .font(Typography.title.font)
                .foregroundColor(.yellow)
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .colorMultiply(optionSelected ? .white : .black)
                    .opacity(optionSelected ? 1.0 : 0.9)
            } placeholder: {
                ProgressView()
            }
            Text(optionSelected ? (name ?? "") : "")
                .font(Typography.header.font)
                .foregroundStyle(.yellow)
        }
    }
}

// MARK: ButtonsView
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

// MARK: OptionsButtonView
struct OptionsButtonView: View {
    var title: String?
    var action: () -> Void
    var optionSelected: Bool
    
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

// MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleGame = Game(currentPokemon: (name: "Option 3", url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png")!),
                              option1: "Option 1", option2: "Option 2",
                              option3: "Option 3", option4: "Option 4")
        let viewModel = ViewModel()
        viewModel.game = sampleGame
        
        return ContentView()
            .environmentObject(viewModel)
    }
}


