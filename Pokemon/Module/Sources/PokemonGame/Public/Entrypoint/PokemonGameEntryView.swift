import SwiftUI
@MainActor
public struct PokemonGameEntryView {
    public static func build() -> some View {
        return PokemonView(viewModel: .init())
    }
}
