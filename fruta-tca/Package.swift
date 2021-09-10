// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "fruta-tca",
  platforms: [.macOS(.v12), .iOS(.v15)],
  products: [
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]
    ),
    .library(
      name: "OrderCore",
      targets: ["OrderCore"]
    ),
    .library(
      name: "SmoothieCore",
      targets: ["SmoothieCore"]
    ),
    .library(
      name: "SwiftUIHelpers",
      targets: ["SwiftUIHelpers"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.27.0"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "SmoothieCore",
        "SwiftUIHelpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "OrderCore",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: []
    ),
    .target(
      name: "SmoothieCore",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SwiftUIHelpers",
      dependencies: []
    ),
  ]
)
