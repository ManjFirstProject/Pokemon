//
//  File.swift
//  Branding
//
//  Created by Manjinder Singh on 30/03/2025.
//

import SwiftUI

extension Font {
    static func regularFont(_ value: CGFloat) -> Font {
        Font.custom("PokemonSolidNormal", size: value)
    }
    
    static func regularHollow(_ value: CGFloat) -> Font {
        Font.custom("PokemonHollowNormal", size: value)
    }
}

