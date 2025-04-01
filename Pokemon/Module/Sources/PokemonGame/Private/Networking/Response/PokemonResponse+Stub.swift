#if DEBUG
extension PokemonResponse {
    static func stub() -> Self {
        Self(
            count: 100,
            next: "",
            previous: "",
            results: []
        )
    }
}
#endif
