import SwiftUI

struct PokemonView: View {
    @ObservedObject private var viewModel: PokemonViewModel

    // MARK: - Life cycle
    init(
        viewModel: PokemonViewModel
    ) {
        self.viewModel = viewModel
    }

    var body: some View {
        GeometryReader { geometry in
            switch viewModel.state {
            case .initial:
                Text("")
                    .onAppear {
                        Task {
                            await viewModel.getPokemons()
                        }
                    }
            case .loading:
                Text("Add a cool loading here")
            case let .loaded(game):
                content(game, geometry)
            case .error:
                Text("Show error view")
            }
        }
    }

    private func content(
        _ game: Game,
        _ proxy: GeometryProxy
    ) -> some View {
        VStack(spacing: 0) {
            TopView(
                optionSelected: $viewModel.selected,
                score: game.score,
                url: game.currentPokemon.url,
                name: game.currentPokemon.name
            )
            .frame(
                width: proxy.size.width,
                height: proxy.size.height * 0.6
            )
            .background(Color.blue)
            
            ButtonsView(
                optionSelected: $viewModel.selected,
                option1: game.option1,
                option2: game.option2,
                option3: game.option3,
                option4: game.option4
            ) { selectedOption in
                viewModel.result(with: selectedOption)
            } reloadAction: {
                viewModel.loadRound()
            } resetAction: {
                viewModel.reset()
            }
            .frame(
                width: proxy.size.width,
                height: proxy.size.height * 0.4
            )
            .background(.gray)
        }
    }
}

#if DEBUG
#Preview {
    PokemonView(
        viewModel: .init()
    )
}
#endif
