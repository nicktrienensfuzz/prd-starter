// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PRDStarter",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/multipart-kit.git", from: "4.0.0"),
        .package(url: "https://github.com/swift-extras/swift-extras-base64.git", .upToNextMinor(from: "0.7.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/skelpo/JSON",from: "1.1.4"),
        .package(url: "https://github.com/hummingbird-project/hummingbird",from: "1.5.1"),
        .package(url: "https://github.com/pointfreeco/swift-tagged",from: "0.10.0"),
        .package(url: "https://github.com/apple/swift-log",from: "1.5.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies",from: "0.5.1"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-auth",from: "1.1.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-lambda",from: "1.0.0-rc.3")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "PRDStarter",
            dependencies: [
                .product(name: "ExtrasBase64", package: "swift-extras-base64"),
                .product(name: "MultipartKit", package: "multipart-kit"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "JSON",package: "JSON"),
                .product(name: "Hummingbird",package: "hummingbird"),
                .product(name: "Tagged",package: "swift-tagged"),
                .product(name: "Logging",package: "swift-log"),
                .product(name: "Dependencies",package: "swift-dependencies"),
                .product(name: "HummingbirdAuth",package: "hummingbird-auth"),
                .product(name: "HummingbirdLambda",package: "hummingbird-lambda")
            ],
            path: "Sources"),
        
    ]
)
