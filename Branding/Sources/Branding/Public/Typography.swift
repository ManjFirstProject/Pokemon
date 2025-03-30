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
    
    public var font: Font {
        switch self {
        case .copy: return .regularHollow(14)
        case .title: return .regularFont(18)
        }
    }
}

