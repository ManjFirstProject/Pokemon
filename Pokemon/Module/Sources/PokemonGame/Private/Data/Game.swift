import Foundation
struct Game {
    let currentPokemon: (name: String, url: URL)
    let option1: String
    let option2: String
    let option3: String
    let option4: String
    var score: Int = 0
}

extension Game {
    mutating func result(with option: String?) {
        if option == currentPokemon.name {
            score += 1
        }
    }
}
