//
//  ViewModel.swift
//  Pokemon
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation
import MyNetworking
import UIKit

struct Game {
    let currentPokemon: (name: String, url: URL)
    let option1: String
    let option2: String
    let option3: String
    let option4: String
}

class ViewModel: ObservableObject {
    
    let networkManager: NetworkProtocol
    
    private var pokemons: [Pokemon] = []
    private var currentLot: [Pokemon] = []
    
    @Published var score = 0
    @Published var game: Game?
    @Published var givenError: String? = nil
    
    @MainActor
    init(networkManager: NetworkProtocol = NetworkManager(URLSession.shared)) {
        self.networkManager = networkManager
        Task {
            do {
                try await getPokemons()
                try await loadRound()
            } catch {
                givenError = error.localizedDescription
            }
        }
    }
    
    @MainActor
    private func getPokemons() async throws {
        do {
            let result = try await self.networkManager.requestWith(.pokemons)
            
            switch result {
            case .failure(let err):
                throw err
            case .success(let data):
                pokemons = try JSONDecoder().decode(PokemonResponse.self, from: data).results
            }
        } catch {
            // Show error
            throw AuthError.network
        }
    }
    
    @MainActor
    func loadRound() async throws {
        currentLot = Array(pokemons.shuffled().prefix(4))
        do {
            guard let pokemon = currentLot.shuffled().first else {
                throw AuthError.coding
            }
            
            let components = pokemon.url.split(separator: "/").filter { !$0.isEmpty }
            guard let pokemonId = components.last, let baseUrl = imageBaseURL else {
                throw AuthError.unknown
            }
            let imageURL = baseUrl.appending(path: "\(pokemonId).png")
            game = Game(currentPokemon: (pokemon.name,
                                         imageURL),
                        option1: currentLot[0].name,
                        option2: currentLot[1].name,
                        option3: currentLot[2].name,
                        option4: currentLot[3].name)
            
        } catch {
            givenError = AuthError.network.localizedDescription
            throw AuthError.network
        }
    }
    
    func result(with selectionOption: String?) {
        if selectionOption == game?.currentPokemon.name {
            score += 1
        }
    }
    
    func reset() {
        score = 0
        Task {
          try? await loadRound()
        }
    }
    
   private var imageBaseURL: URL? {
        guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/") else {
            return nil
        }
        return url
    }
    
    private func imageLoader(imageId: String) async throws -> UIImage {
        do {
            let result = try await self.networkManager.requestWith(.image(imageId))
            switch result {
            case .failure(let err):
                throw err
            case .success(let data):
                guard let image  = UIImage(data: data) else {
                    throw AuthError.coding
                }
                return image
            }
        } catch {
            throw AuthError.network
        }
    }
}
