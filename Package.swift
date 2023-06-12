// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AssociatedObject",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "AssociatedObject",
            targets: ["AssociatedObject"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "AssociatedObject",
            dependencies: [
                "AssociatedObjectPlugin"
            ]
        ),
        .macro(
            name: "AssociatedObjectPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax")
            ]
        ),
        .testTarget(
            name: "AssociatedObjectTests",
            dependencies: ["AssociatedObject"]
        ),
    ]
)
