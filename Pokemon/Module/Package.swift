// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    defaultLocalization: "en",
    platforms: [ .iOS(.v16) ],
    products: [
        // MARK: - Horizontals
        .library(name: "Networking", targets: ["Networking"]),

        // MARK: - Supports
        .library(name: "UISupport", targets: ["UISupport"]),
       

        // MARK: - Feature Verticals
        .library(name: "PokemonGame", targets: ["PokemonGame"]),

        // MARK: - Design
        .library(name: "Designs", targets: ["Designs"]),

        // MARK: - Testing
        .library(name: "TestingSupport", targets: ["TestingSupport"]),
    ]
)


// MARK: - Horizontals
package.targets.append(contentsOf: [
    .target(
        name: "Designs",
        resources: [
            .process("Resources")
        ]
    ),
    .testTarget(
        name: "DesignsTests",
        dependencies: [
            "Designs"
        ]
    ),
    .target(
        name: "Networking",
        dependencies: [
        ]
    ),
    .testTarget(
        name: "NetworkingTests",
        dependencies: [
            "Networking"
        ]
    )
])

// MARK: - Support
package.targets.append(contentsOf: [
    .target(
        name: "UISupport",
        dependencies: [
        ]
    ),
    .testTarget(
        name: "UISupportTests",
        dependencies: [
            "UISupport"
        ]
    )
])

// MARK: - Vertical: Pokemon
package.targets.append(contentsOf: [
    .target(
        name: "PokemonGame",
        dependencies: [
            "Designs",
            "Networking"
        ]
    ),
    .testTarget(
        name: "PokemonGameTests",
        dependencies: [
            "PokemonGame",
            "TestingSupport"
        ]
    )
])

// MARK: - Testing
package.targets.append(contentsOf: [
    .target(
        name: "TestingSupport",
        dependencies: [
        ]
    )
])
