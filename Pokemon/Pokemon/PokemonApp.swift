//
//  PokemonApp.swift
//  Pokemon
//
//  Created by Manjinder Singh on 29/03/2025.
//

import SwiftUI
import Designs
import PokemonGame

@main
struct PokemonApp: App {
    // MARK: - Life cycle
    init() {
        _ = FontRegistry.live().register()
    }

    var body: some Scene {
        WindowGroup {
            PokemonGameEntryView.build()
        }
    }
}
