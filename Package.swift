// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Lilliput",
    platforms: [
        .iOS(.v16),
        .macOS(.v11),
        .watchOS(.v9),
    ],
    products: [
        .library(
            name: "Lilliput",
            targets: [
                "Lilliput",
            ]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-system.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Lilliput",
            dependencies: [
                .product(name: "SystemPackage", package: "swift-system"),
            ]
        ),
        .testTarget(
            name: "LilliputTests",
            dependencies: [
                "Lilliput",
            ]
        ),
    ]
)
