// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Lilliput",
    products: [
        .library(name: "Lilliput", targets: ["Lilliput"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Lilliput", dependencies: []),
        .testTarget(name: "LilliputTests", dependencies: ["Lilliput"]),
    ]
)
