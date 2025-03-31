//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation
import MyNetworking

public enum RestAPI: EndPointType, Sendable {
    case pokemons
    case image(String)
}

extension RestAPI {
    
    private var environmentBaseURL: String {
        switch NetworkConfiguration.shared.environment {
        case .dev:
            return "https://pokeapi.co/api/v2/"
        case .production:
            return "https://pokeapi.co/api/v2/"
        case .staging:
            return "https://pokeapi.co/api/v2/"
        }
    }
    
    public var baseURL: URL {
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
    
    public var path: String {
        switch self {
        case .pokemons:
            return "pokemon"
        case .image(let id):
            return "\(id).png"
        }
    }
    
    public var httpMethod: HTTPMethod {
        switch self {
        case .pokemons, .image(_):
            return .get
        }
    }
    
    public func task() async -> HTTPTask {
        switch self {
        case .pokemons:
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: .urlEncoding,
                                      urlParameters: ["limit": "150", "offset": "0"])
        case .image(_):
            return .request
        }
    }
    
    public func headers() async -> HTTPHeaders? {
        return nil
    }
}
