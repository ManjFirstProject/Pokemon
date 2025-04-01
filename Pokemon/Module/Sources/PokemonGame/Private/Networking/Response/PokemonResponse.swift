struct PokemonResponse: Decodable {
    struct Pokemon: Codable {
        let name: String
        let url: String
    }

    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
}


