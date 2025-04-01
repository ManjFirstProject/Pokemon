import SwiftUI
import Networking

class PokemonViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case loaded(Game)
        case error(String)
    }

    @Published var selected: Bool = false
    @Published private(set) var state: State

    private var response: PokemonResponse?
    private let repository: PokemonRepository

    // MARK: - Life cycle
    init(
        state: State = .initial,
        repository: PokemonRepository = .live()
    ) {
        self.state = state
        self.repository = repository
    }

    @MainActor
    func getPokemons() async {
        state = .loading

        do {
            let response = try await repository
                .fetch(
                    ["limit": "150", "offset": "0"]
                )
            let game = try response.mapToGame

            withAnimation {
                state = .loaded(game)
            }
            self.response = response
        } catch {
            state = .error(error.message)
        }
    }

    func loadRound() {
        guard let response = response,
              let game = try? response.mapToGame
        else { return }
        selected = false
        state = .loaded(game)
    }

    func reset() {
        selected = false
    }

    func result(with option: String?) {
        guard case var .loaded(game) = state else { return }
        game.result(with: option)
        state = .loaded(game)
        selected = true
    }
}

private extension Error {
    var message: String {
        let apiError = self as? API.Error
        let gameError = self as? GameError

        // API errors
        if let apiError = apiError {
            switch apiError {
            case .decode: return "Invalid data"
            case .server: return "Something went wrong"
            case .client: return "Something went wrong"
            case .noConnection: return "No connection"
            case .unauthorised: return "Not authorised"
            }
        }

        // Not sure what these errors mean
        if let gameError = gameError {
            switch gameError {
            case .coding: return "Coding issue"
            case .network: return "Game network issue"
            case .unknown: return "Something went wrong"
            }
        }

        return "Something went wrong"
    }
}
