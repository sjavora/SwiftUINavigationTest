// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Navigation",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Navigation", targets: ["Navigation"]),
    ],
    targets: [
        .target(name: "Navigation")
    ]
)
