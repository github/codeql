// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "B",
    products: [
        .library(
            name: "B",
            targets: ["B"]),
    ],
    targets: [
        .target(
            name: "B",
            dependencies: []),
    ]
)
