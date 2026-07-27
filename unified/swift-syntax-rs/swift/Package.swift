// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "SwiftSyntaxFFI",
    platforms: [
        // swift-syntax 603 requires macOS 10.15; declare it explicitly
        // rather than relying on the swift-tools-version default (10.13).
        .macOS(.v10_15),
    ],
    products: [
        // Dynamic library so the produced .so records its dependency on the
        // Swift runtime libraries, keeping the Rust link step simple.
        .library(
            name: "SwiftSyntaxFFI",
            type: .dynamic,
            targets: ["SwiftSyntaxFFI"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            exact: "603.0.2"
        )
    ],
    targets: [
        .target(
            name: "SwiftSyntaxFFI",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftParser", package: "swift-syntax"),
            ]
        )
    ]
)
