//
//  File.swift
//  Branding
//
//  Created by Manjinder Singh on 30/03/2025.
//

import Foundation
import SwiftUI

public struct FontRegistry {
    /// Register fonts for app launch
    public let register: () -> Bool
}

public extension FontRegistry {
    static func live() -> Self {
        let fonts = [
            "PokemonSolid",
            "PokemonHollow"
        ]

        return Self(
            register: {
                fonts
                    .map(UIFont.register(_:))
                    .allSatisfy { $0 }
            }
        )
    }
}

private extension UIFont {
    static func register(_ fontName: String) -> Bool {

        guard
            let fontURL = Bundle.module.url(
                forResource: fontName, withExtension: "ttf"
            )
        else {
            return false
        }

        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
              let font = CGFont(fontDataProvider)
        else {
            return false
        }

        var error: Unmanaged<CFError>?
        _ = CTFontManagerRegisterGraphicsFont(font, &error)

        return true
    }
}
