// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConfluenceReader",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .library(name: "ConfluenceAPI", targets: ["ConfluenceAPI"]),
        .library(name: "JiraClient", targets: ["JiraClient"]),
        .library(name: "SmartSheetClient", targets: ["SmartSheetClient"]),
        .library(name: "Networker", targets: ["Networker"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/PathKit.git", from: "1.0.1"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", branch: "main"),
        .package(url: "https://github.com/skelpo/JSON", from: "1.1.4"),
        .package(url: "https://github.com/apple/swift-atomics.git", from: "1.0.2"),
        .package(path: "../Dependency"),
        .package(url: "https://github.com/sindresorhus/Regex.git", branch: "main"),
        .package(url: "https://github.com/scinfu/SwiftSoup.git", branch: "master"),
        .package(url: "https://github.com/tadija/AEXML", from: "4.6.1"),
        .package(url: "https://github.com/stencilproject/Stencil.git", from: "0.15.1"),
        .package(url: "https://github.com/pointfreeco/swift-tagged.git", from: "0.7.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.2.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.42.0"),

    ],
    targets: [
        .target(
            name: "ConfluenceAPI",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "DependencyContainer", package: "Dependency"),
                .product(name: "JSON", package: "JSON"),
                .product(name: "AEXML", package: "AEXML"),
                .product(name: "Stencil", package: "Stencil"),
                .product(name: "Atomics", package: "swift-atomics"),
                "Regex",
                "SwiftSoup",
                "Networker"
            ]
        ),
        .target(
            name: "Networker",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "DependencyContainer", package: "Dependency"),
                .product(name: "JSON", package: "JSON"),
                .product(name: "Atomics", package: "swift-atomics"),
                .product(name: "NIOFoundationCompat", package: "swift-nio")
            ]
        ),
        .target(
            name: "JiraClient",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "DependencyContainer", package: "Dependency"),
                .product(name: "JSON", package: "JSON"),
                "Networker",
                "Regex"
            ]
        ),
        .target(
            name: "SmartSheetClient",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "DependencyContainer", package: "Dependency"),
                .product(name: "JSON", package: "JSON"),
                .product(name: "Tagged", package: "swift-tagged"),
                "Networker"
            ]
        ),
        
        .executableTarget(
            name: "ConfluenceReader",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                //  .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "PathKit", package: "PathKit"),
                .product(name: "DependencyContainer", package: "Dependency"),
                .product(name: "JSON", package: "JSON"),
                .product(name: "AEXML", package: "AEXML"),
                .product(name: "Stencil", package: "Stencil"),
                "Regex",
                "SwiftSoup",
                "ConfluenceAPI",
                "JiraClient"
            ]
        ),
        .testTarget(
            name: "ConfluenceReaderTests",
            dependencies: ["ConfluenceReader"]
        )
    ]
)
