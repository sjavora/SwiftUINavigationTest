// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MMB",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "MMB", targets: ["MMB"]),
        .library(name: "MMBViews", targets: ["MMBViews"]),
        .library(name: "MMBImplementation", targets: ["MMBImplementation"]),
    ],
    dependencies: [
        .package(path: "../Login"),
        .package(path: "../Navigation"),
        .package(path: "../UserStorage"),
    ],
    targets: [
        .target(
            name: "MMB",
            dependencies: ["Navigation"]
        ),
        .target(
            name: "MMBViews",
            dependencies: [
                "Login",
                .product(name: "LoginViews", package: "Login"),
                "MMB",
                "Navigation",
                "UserStorage",
                .product(name: "UserStorageMocks", package: "UserStorage"),
            ]
        ),
        .target(
            name: "MMBImplementation",
            dependencies: [
                "MMB",
                "MMBViews"
            ]
        ),
    ]
)
