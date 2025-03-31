//
//  File.swift
//  MyNetworking
//
//  Created by Manjinder Singh on 29/03/2025.
//

import Foundation

public struct PokemonResponse: Codable {
    public let count: Int
    public let next: String?
    public let previous: String?
    public let results: [Pokemon]
}

public struct Pokemon: Codable {
    public let name: String
    public let url: String
}
