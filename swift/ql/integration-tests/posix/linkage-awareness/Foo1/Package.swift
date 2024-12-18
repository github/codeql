// swift-tools-version: 5.7

import PackageDescription

let package = Package(
        name: "Foo",
        products: [
            .executable(
                    name: "foo",
                    targets: ["foo"]),
        ],
        targets: [
            .executableTarget(
                    name: "foo",
                    dependencies: []),
        ]
)
