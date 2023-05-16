// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserStorage",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "UserStorage", targets: ["UserStorage"]),
        .library(name: "UserStorageImplementation", targets: ["UserStorageImplementation"]),
    ],
    dependencies: [
        .package(path: "../Navigation"),
    ],
    targets: [
        .target(name: "UserStorage", dependencies: ["Navigation"]),
        .target(name: "UserStorageImplementation", dependencies: ["UserStorage"]),
    ]
)
