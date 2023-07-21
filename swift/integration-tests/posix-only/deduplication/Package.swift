// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "deduplication",
    products: [
        .library(
            name: "deduplication",
            targets: ["deduplication"]),
    ],
    targets: [
        .target(name: "deduplication")
    ]
)
