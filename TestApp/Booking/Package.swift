// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Booking",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Booking", targets: ["Booking"]),
        .library(name: "BookingViews", targets: ["BookingViews"]),
    ],
    dependencies: [
        .package(path: "../Navigation"),
    ],
    targets: [
        .target(name: "Booking", dependencies: ["Navigation"]),
        .target(name: "BookingViews", dependencies: ["Booking", "Navigation"]),
    ]
)
