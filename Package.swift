// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlayIndicator",
    platforms: [
        .iOS(.v13), .watchOS(.v6), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "PlayIndicator",
            targets: ["PlayIndicator"]),
    ],
    targets: [
        .target(
            name: "PlayIndicator",
            dependencies: []),
    ]
)
