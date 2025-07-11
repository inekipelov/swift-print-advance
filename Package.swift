// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-print-advance",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "PrintAdvance",
            targets: ["PrintAdvance"]),
    ],
    targets: [
        .target(
            name: "PrintAdvance",
            dependencies: [],
            path: "Sources"),
        .testTarget(
            name: "PrintAdvanceTests",
            dependencies: ["PrintAdvance"],
            path: "Tests"),
    ]
)