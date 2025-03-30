//
//  ViewModel.swift
//  Pokemon
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation
import MyNetworking
import UIKit
import Combine

struct Game {
    let currentPokemon: (name: String, image: UIImage)
    let option1: String
    let option2: String
    let option3: String
    let option4: String
}

class ViewModel: ObservableObject {
    
    let networkManager: NetworkProtocol
    private var pokemons: [Pokemon] = []
    private var currentLot: [Pokemon] = []
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var score = 0
    
    @Published var game: Game?
    @Published var givenError: String?
    @Published var selectedOption: String?
    
    @MainActor
    init(networkManager: NetworkProtocol = NetworkManager(URLSession.shared)) {
        self.networkManager = networkManager
        Task {
            do {
                try await getPokemons()
                try await nextGame()
                result()
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
    func nextGame() async throws {
        currentLot = Array(pokemons.shuffled().prefix(4))
        do {
            guard let pokemon = currentLot.shuffled().first else {
                return
            }
            
            let components = pokemon.url.split(separator: "/").filter { !$0.isEmpty }
            guard let pokemonId = components.last else {
                throw AuthError.unknown
            }
            let pokemonImage = try await imageLoader(imageId: String(pokemonId))
            
            game = Game(currentPokemon: (pokemon.name, pokemonImage),
                        option1: currentLot[0].name,
                        option2: currentLot[1].name,
                        option3: currentLot[2].name,
                        option4: currentLot[3].name)
            
        } catch {
            throw AuthError.network
        }
    }
    
    private func result() {
        $selectedOption
            .compactMap { $0 }
            .sink { [weak self] option in
                if option == self?.game?.currentPokemon.name {
                    self?.score += 1
                }
            }
            .store(in: &cancellables)
    }
    
    func reset() {
        score = 0
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
