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
        .package(
            url: "https://github.com/apple/swift-syntax.git",
            from: "509.0.0"
        ),
        .package(
            url: "https://github.com/p-x9/swift-literal-type-inference.git",
            from: "0.1.0"
        ),
        .package(
            url: "https://github.com/p-x9/swift-object-association.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/pointfreeco/swift-macro-testing.git",
            from: "0.2.2"
        )

    ],
    targets: [
        .target(
            name: "AssociatedObject",
            dependencies: [
                "AssociatedObjectC",
                "AssociatedObjectPlugin",
                .product(
                    name: "ObjectAssociation",
                    package: "swift-object-association",
                    condition: .when(
                        platforms: [
                            .linux, .openbsd, .windows, .android
                        ]
                    )
                )
            ]
        ),
        .target(
            name: "AssociatedObjectC"
        ),
        .macro(
            name: "AssociatedObjectPlugin",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftParserDiagnostics", package: "swift-syntax"),
                .product(
                    name: "LiteralTypeInference",
                    package: "swift-literal-type-inference"
                )
            ]
        ),
        .testTarget(
            name: "AssociatedObjectTests",
            dependencies: [
                "AssociatedObject",
                "AssociatedObjectPlugin",
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftSyntaxBuilder", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
                .product(name: "MacroTesting", package: "swift-macro-testing")
            ]
        ),
    ]
)
