// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Search",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Search", targets: ["Search"]),
        .library(name: "SearchViews", targets: ["SearchViews"]),
        .library(name: "SearchImplementation", targets: ["SearchImplementation"]),
    ],
    dependencies: [
        .package(path: "../Booking"),
        .package(path: "../Navigation"),
    ],
    targets: [
        .target(name: "Search", dependencies: ["Navigation"]),
        .target(name: "SearchViews", dependencies: ["Booking", "Navigation", "Search"]),
        .target(name: "SearchImplementation", dependencies: ["Booking", "Search", "SearchViews"]),
    ]
)
