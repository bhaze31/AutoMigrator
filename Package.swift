// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutoMigrator",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AutoMigrator",
            targets: ["AutoMigrator"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.55.0"),
        .package(url: "https://github.com/vapor/fluent.git", from: "4.4.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AutoMigrator",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Fluent", package: "fluent")
            ]),
        .testTarget(
            name: "AutoMigratorTests",
            dependencies: ["AutoMigrator"]),
    ]
)
