import Foundation
enum GameError: Error {
    case coding
    case network
    case unknown
}
extension PokemonResponse {
    private static let imageBaseURL = URL(
        string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/"
    )
    var mapToGame: Game {
        get throws {
            var lot = Array(results.shuffled().prefix(4))
            do {
                guard let shuffled = lot.shuffled().first else {
                    throw GameError.coding
                }
                
                let components = shuffled.url
                    .split(separator: "/")
                    .filter { !$0.isEmpty }
                
                guard let id = components.last,
                      let baseUrl = Self.imageBaseURL
                else {
                    throw GameError.unknown
                }
                
                let imageURL = baseUrl.appending(path: "\(id).png")
                return .init(
                    currentPokemon: (shuffled.name, imageURL),
                    option1: lot[0].name,
                    option2: lot[1].name,
                    option3: lot[2].name,
                    option4: lot[3].name
                )
                
            } catch {
                throw GameError.network
            }
        }
    }
}
