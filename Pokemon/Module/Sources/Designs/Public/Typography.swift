//
//  File.swift
//  Branding
//
//  Created by Manjinder Singh on 30/03/2025.
//

import SwiftUI

public enum Typography: CaseIterable {
    case title
    case copy
    case header
    
    public var font: Font {
        switch self {
        case .copy: return .hollow(14)
        case .title: return .solid(18)
        case .header: return .solid(28)
        }
    }
}

