// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Lilliput",
    products: [
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "Lilliput", dependencies: []),
        .testTarget(name: "LilliputTests", dependencies: ["Lilliput"]),
    ]
)

#if os(Linux) || os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
package.targets.append(.target(name: "POSIX", dependencies: ["Lilliput"]))
package.products.append(.library(name: "Lilliput", targets: ["Lilliput", "POSIX"]))
#endif
