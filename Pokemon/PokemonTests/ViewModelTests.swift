//
//  ViewModelTests.swift
//  PokemonTests
//
//  Created by Manjinder Singh on 30/03/2025.
//

import XCTest
import Combine
import MyNetworking
@testable import Pokemon
import SwiftUICore
import SwiftUI

final class ViewModelTests: XCTestCase {
    var viewModel: ViewModel!
    var networkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable> = []
    
    
    override func setUp() {
        super.setUp()
        let expectation = XCTestExpectation(description: "ViewModel Initialization")
        Task {
            networkManager = MockNetworkManager()
            viewModel = await ViewModel(networkManager: networkManager)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    override func tearDown() {
        viewModel = nil
        networkManager = nil
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertEqual(viewModel.score, 0)
        XCTAssertNil(viewModel.game)
        XCTAssertNil(viewModel.givenError)
    }
    
    func testScoreUpdateWhenAnswerIsCorrect() {
        
        viewModel.score = 0
        viewModel.game = Game(currentPokemon: ("Pikachu", UIImage()),
                              option1: "Pikachu",
                              option2: "Charmander",
                              option3: "Bulbasaur",
                              option4: "Squirtle")
        
        viewModel.result(with: "Pikachu")
        XCTAssertEqual(viewModel.score, 1)
    }
    
    func testScoreRemainsSameWhenAnswerIsIncorrect() {
        viewModel.score = 0
        viewModel.game = Game(currentPokemon: ("Pikachu", UIImage()),
                              option1: "Charmander",
                              option2: "Bulbasaur",
                              option3: "Squirtle",
                              option4: "Eevee")
        viewModel.result(with: "Charmander")
        XCTAssertEqual(viewModel.score, 0)
    }
    
    func testResetScore() {
        viewModel.score = 5
        viewModel.reset()
        XCTAssertEqual(viewModel.score, 0)
    }
    
    func testLoadRoundWithError() async {
        networkManager.shouldReturnError = true
        try? await viewModel.loadRound()
        XCTAssertNotNil(viewModel.givenError)
        XCTAssertNil(viewModel.game)
    }
    
    func testLoadPokemonsFailure() async {
        networkManager.shouldReturnError = true
        do {
            try await viewModel.loadRound()
            XCTFail("Expected an error but got success")
        } catch {
            XCTAssertNotNil(AuthError.network)
        }
    }
}

class MockNetworkManager: NetworkProtocol {
    var shouldReturnError = false
    func requestWith(_ route: RestAPI) async throws -> Result<Data, AuthError> {
        if shouldReturnError {
            throw AuthError.network
        }
        
        switch route {
        case .pokemons:
            return .success(pokemonResponseData)
        case .image(_):
            do {
                if let image = UIImage(named: "SamplePokemon"), let data = image.pngData() {
                    return .success(data)
                } else {
                    throw AuthError.coding
                }
           
            } catch {
                throw AuthError.coding
            }
        }
    }
    
    var pokemonResponseData: Data {
        let jsonData = """
           {
               "count": 1302,
               "next": "https://pokeapi.co/api/v2/pokemon/?offset=40&limit=20",
               "previous": "https://pokeapi.co/api/v2/pokemon/?offset=0&limit=20",
               "results": [
                   {"name": "spearow", "url": "https://pokeapi.co/api/v2/pokemon/21/"},
                   {"name": "fearow", "url": "https://pokeapi.co/api/v2/pokemon/22/"},
                   {"name": "ekans", "url": "https://pokeapi.co/api/v2/pokemon/23/"},
                   {"name": "arbok", "url": "https://pokeapi.co/api/v2/pokemon/24/"},
                   {"name": "pikachu", "url": "https://pokeapi.co/api/v2/pokemon/25/"},
                   {"name": "raichu", "url": "https://pokeapi.co/api/v2/pokemon/26/"},
                   {"name": "sandshrew", "url": "https://pokeapi.co/api/v2/pokemon/27/"},
                   {"name": "sandslash", "url": "https://pokeapi.co/api/v2/pokemon/28/"},
                   {"name": "nidoran-f", "url": "https://pokeapi.co/api/v2/pokemon/29/"},
                   {"name": "nidorina", "url": "https://pokeapi.co/api/v2/pokemon/30/"}
               ]
           }
"""
        
        return Data(jsonData.utf8)
    }
}
