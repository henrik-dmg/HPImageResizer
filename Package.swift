// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ImageResizer",
    platforms: [
        .macOS(.v10_14)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "ImageResizer",
            targets: ["ImageResizer"]),
        .executable(
            name: "hpresizer",
            targets: ["ImageResizerCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.0.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(name: "ImageResizer"),
        .target(
            name: "ImageResizerCLI",
            dependencies: ["ImageResizer", "ArgumentParser"]),
        .testTarget(
            name: "ImageResizerTests",
            dependencies: ["ImageResizer"]),
    ]
)
