// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftMatrix",
    products: [
        .library(
            name: "SwiftMatrix",
            targets: ["SwiftMatrix"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftMatrix",
            dependencies: []),
        .testTarget(
            name: "SwiftMatrixTests",
            dependencies: ["SwiftMatrix"]),
    ]
)
