// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "partial-modules",
    products: [
        .library(
            name: "partial-modules",
            targets: ["partial-modules"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "./A"),
        .package(path: "./B"),
    ],
    targets: [
        .target(
            name: "partial-modules",
            dependencies: ["A", "B"]),
    ]
)
