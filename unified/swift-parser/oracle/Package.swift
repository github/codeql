// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SwiftSyntaxOracle",
    platforms: [
        // swift-syntax 604 requires macOS 10.15; declare it explicitly
        // rather than relying on the swift-tools-version default (10.13).
        .macOS(.v10_15),
    ],
    products: [
        .executable(
            name: "swift-syntax-parse",
            targets: ["SwiftSyntaxOracle"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            exact: "604.0.0"
        )
    ],
    targets: [
        .executableTarget(
            name: "SwiftSyntaxOracle",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
                .product(name: "SwiftOperators", package: "swift-syntax"),
            ]
        )
    ]
)
