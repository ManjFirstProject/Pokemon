//
//  PokemonApp.swift
//  Pokemon
//
//  Created by Manjinder Singh on 29/03/2025.
//

import SwiftUI
import Branding
@main
struct PokemonApp: App {
    init() {
            FontLoader.loadCustomFont()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
