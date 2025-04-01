//
//  File.swift
//  Branding
//
//  Created by Manjinder Singh on 30/03/2025.
//

import SwiftUI

extension Font {
    enum `Type`: String {
        case solid = "Solid"
        case hollow = "Hollow"
    }

    private static func font(
        _ type: `Type`,
        _ size: CGFloat
    ) -> Font {
        .custom("Pokemon\(type.rawValue)Normal", size: size)
    }

    static func hollow(
        _ size: CGFloat
    ) -> Font {
        return Self.font(.hollow, size)
    }

    static func solid(
        _ size: CGFloat
    ) -> Font {
        return .font(.solid, size)
    }
}

