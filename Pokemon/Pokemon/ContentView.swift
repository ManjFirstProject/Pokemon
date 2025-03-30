//
//  ContentView.swift
//  Pokemon
//
//  Created by Manjinder Singh on 29/03/2025.
//

import SwiftUI
import Branding

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var optionSelected: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack (spacing: 0) {
                    TopView(viewModel: viewModel,
                            optionSelected: optionSelected)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.6)
                    .background(Color.blue)
                    ButtonsView(viewModel: viewModel,
                                optionSelected: $optionSelected)
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.4)
                    .background(.gray)
                }
        }
    }
}

struct TopView: View {
    @ObservedObject var viewModel: ViewModel
    var optionSelected: Bool
    
    var body: some View {
        VStack {
            if let game = viewModel.game {
                Text("Score: \(viewModel.score)")
                    .padding(.bottom, 60)
                    .font(Typography.title.font)
                    .foregroundColor(.white)
                Image(uiImage: game.currentPokemon.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .colorMultiply(optionSelected ? .white : .black)
                    .opacity(optionSelected ? 1.0 : 0.9)
                
                Text(optionSelected ? viewModel.game?.currentPokemon.name ?? "" : "")
                    .font(Typography.title.font)
            } else {
                ProgressView()
            }
        }
    }
}

struct ButtonsView: View {
    @ObservedObject var viewModel: ViewModel
    @Binding var optionSelected: Bool
    
    var body: some View {
        VStack (spacing: 10) {
            HStack (spacing: 30) {
                OptionsButtonView(title: viewModel.game?.option1, action: {
                    viewModel.selectedOption = viewModel.game?.option1
                    optionSelected = true
                }, optionSelected: optionSelected)
                OptionsButtonView(title: viewModel.game?.option2, action: {
                    viewModel.selectedOption = viewModel.game?.option2
                    optionSelected = true
                }, optionSelected: optionSelected)
            }
            HStack (spacing: 30) {
                OptionsButtonView(title: viewModel.game?.option3, action: {
                    viewModel.selectedOption = viewModel.game?.option3
                    optionSelected = true
                }, optionSelected: optionSelected)
                OptionsButtonView(title: viewModel.game?.option4, action: {
                    viewModel.selectedOption = viewModel.game?.option4
                    optionSelected = true
                }, optionSelected: optionSelected)
            }
            HStack (spacing: 30) {
                GameButtonsView(title: "Next", action: {
                    Task {
                        optionSelected = false
                        try? await viewModel.nextGame()
                    }
                }, optionSelected: optionSelected)
                
                GameButtonsView(title: "Reset", action: {
                    optionSelected = false
                    viewModel.reset()
                    
                })
            }
        }
    }
}

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleGame = Game(currentPokemon: (name: "Option 3", image: UIImage(named: "SamplePokemon")!),
                              option1: "Option 1", option2: "Option 2",
                              option3: "Option 3", option4: "Option 4")
        let viewModel = ViewModel()
        viewModel.game = sampleGame
        
        return ContentView()
            .environmentObject(viewModel)
    }
}


