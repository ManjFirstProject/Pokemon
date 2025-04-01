#if DEBUG
extension PokemonRepository {
    static func mock(
        fetch: @escaping () async throws -> PokemonResponse = { .stub() }
    ) -> Self {
        Self { queries in
            return try await fetch()
        }
    }
}

#endif
