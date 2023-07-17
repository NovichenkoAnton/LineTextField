// swift-tools-version: 5.4

import PackageDescription

let package = Package(
    name: "LineTextField",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "LineTextField",
            targets: ["LineTextField"]),
    ],
    targets: [
        .target(
            name: "LineTextField",
            path: "Sources"
        )
    ]
)
