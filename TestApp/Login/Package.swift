// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Login",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Login", targets: ["Login"]),
        .library(name: "LoginViews", targets: ["LoginViews"]),
        .library(name: "LoginImplementation", targets: ["LoginImplementation"]),
    ],
    dependencies: [
        .package(path: "../Navigation"),
        .package(path: "../UserStorage"),
    ],
    targets: [
        .target(name: "Login", dependencies: ["Navigation"]),
        .target(name: "LoginViews", dependencies: ["Login", "Navigation", "UserStorage"]),
        .target(name: "LoginImplementation", dependencies: ["Login", "LoginViews", "UserStorage"]),
    ]
)
