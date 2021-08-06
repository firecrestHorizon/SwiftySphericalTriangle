// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftySphericalTriangle",
    products: [
        .library(
            name: "SwiftySphericalTriangle",
            targets: ["SwiftySphericalTriangle"]),
    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftySphericalTriangle",
            dependencies: []),
        .testTarget(
            name: "SwiftySphericalTriangleTests",
            dependencies: ["SwiftySphericalTriangle"]),
    ]
)
