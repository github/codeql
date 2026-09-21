// swift-tools-version: 6.3

import PackageDescription

// This targetless package lets editor tooling discover the standalone Swift test fixtures.
let package = Package(
    name: "CodeQLSwiftFixtures",
    targets: []
)
