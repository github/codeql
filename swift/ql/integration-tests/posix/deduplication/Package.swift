// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "deduplication",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "deduplication",
            targets: ["deduplication"]),
    ],
    targets: [
        .target(name: "deduplication")
    ]
)
