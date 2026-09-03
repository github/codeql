// swift-tools-version:5.9
import PackageDescription

// `schemagen` regenerates `unified/extractor/swift_node_types.yml`, the input
// schema describing the shape of the trees produced by
// `swift_syntax_rs::parse_to_json`. Run it through
// `unified/scripts/regenerate-node-types.sh`, which stages the sources this
// package needs; see `README.md` for the details.
//
// The tools version is deliberately older than the FFI package's: it selects
// the Swift 5 language mode, and `SyntaxSupport` (see below) is not clean under
// Swift 6 strict concurrency because its node tables are non-Sendable globals.
let package = Package(
    name: "schemagen",
    platforms: [
        // Matches the FFI package: swift-syntax 603 requires macOS 10.15.
        .macOS(.v10_15),
    ],
    dependencies: [
        // Keep this independent pin synchronized with the swift-syntax pins in
        // `../swift/Package.swift` and the repository's `MODULE.bazel`.
        .package(
            url: "https://github.com/swiftlang/swift-syntax.git",
            exact: "603.0.2"
        ),
    ],
    targets: [
        // `SyntaxSupport` is a target of swift-syntax's separate
        // `CodeGeneration` package, not a product of swift-syntax itself, so it
        // cannot be depended on directly. The regeneration script copies its
        // sources here (the directory is git-ignored) and this target builds
        // them as if they were our own.
        .target(
            name: "SyntaxSupport",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
            ]
        ),
        .executableTarget(name: "schemagen", dependencies: ["SyntaxSupport"]),
    ]
)
