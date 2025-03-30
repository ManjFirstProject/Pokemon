//
//  File.swift
//  Branding
//
//  Created by Manjinder Singh on 30/03/2025.
//

import Foundation
import SwiftUI

public struct FontLoader {
    public static func loadCustomFont() {
        let bundle = Bundle.module
        let fontName = "Pokemon Solid" 
        
        guard let url = bundle.url(forResource: fontName, withExtension: "ttf"),
              let fontDataProvider = CGDataProvider(url: url as CFURL),
              let font = CGFont(fontDataProvider) else {
            print("Failed to load font from package.")
            return
        }

        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterGraphicsFont(font, &error) {
            print("Failed to register font: \(error.debugDescription)")
        } else {
            print("Successfully registered font: \(fontName)")
        }
    }
}
