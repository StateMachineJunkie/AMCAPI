// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AMCAPI",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(name: "AMCAPI", targets: ["AMCAPI"]),
    ],
    targets: [
        .target(name: "APICore"),
        .target(name: "AMCAPI", dependencies: ["APICore"]),
        .testTarget(name: "AMCAPITests", dependencies: ["AMCAPI"]),
    ]
)
