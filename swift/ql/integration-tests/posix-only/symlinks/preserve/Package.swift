// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "preserve",
    products: [
        .library(
            name: "preserve",
            targets: ["preserve"]),
    ],
    targets: [
        .target(
            name: "preserve",
            path: "Sources"),
    ]
)
