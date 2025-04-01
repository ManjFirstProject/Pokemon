import Networking
struct PokemonRepository {
    let fetch: (_ queries: [String: String]) async throws -> PokemonResponse
}

extension PokemonRepository {
    static func live(
        apiClient: API.Client = .live(),
        decoder: DecodeDataMapper<PokemonResponse> = .live()
    ) -> Self {
        Self { queries in
            let data = try await apiClient
                .makeRequest(
                    .bare(
                        path: "pokemon",
                        method: .get
                    )
                )
            return try decoder.map(data)
        }
    }
}
