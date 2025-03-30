//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation

public enum RestAPI: EndPointType, Sendable {
    case pokemons
    case image(String)
}

extension RestAPI {
    
    private var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .dev:
            return "https://pokeapi.co/api/v2/"
        case .production:
            return "https://pokeapi.co/api/v2/"
        case .staging:
            return "https://pokeapi.co/api/v2/"
        }
    }
    
    var baseURL: URL {
        switch self {
        case .pokemons:
            guard let url = URL(string: environmentBaseURL) else {
                fatalError("Invalid Base URL")
            }
            return url
        case .image:
            guard let url = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/") else {
                fatalError("Invalid Base URL")
            }
            return url
        }
    }
    
    var path: String {
        switch self {
        case .pokemons:
            return "pokemon"
        case .image(let id):
            return "\(id).png"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .pokemons, .image(_):
            return .get
        }
    }
    
    func task() async -> HTTPTask {
        switch self {
        case .pokemons:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["limit": "150", "offset": "0"])
        case .image(_):
            return .request
        }
    }
    
    func headers() async -> HTTPHeaders? {
        return nil
    }
}
