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
      name: "AccountCore",
      targets: ["AccountCore"]
    ),
    .library(
      name: "OrderFeature",
      targets: ["OrderFeature"]
    ),
    .library(
      name: "RewardsFeature",
      targets: ["RewardsFeature"]
    ),
    .library(
      name: "SmoothieCore",
      targets: ["SmoothieCore"]
    ),
    .library(
      name: "SwiftUIHelpers",
      targets: ["SwiftUIHelpers"]
    ),
    .library(
      name: "TCAHelpers",
      targets: ["TCAHelpers"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "0.27.0"),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "AccountCore",
        "SmoothieCore",
        "SwiftUIHelpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AccountCore",
      dependencies: [
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "OrderFeature",
      dependencies: [
        "AccountCore",
        "SharedModels",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RewardsFeature",
      dependencies: [
        "AccountCore",
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
        "AccountCore",
        "TCAHelpers",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SwiftUIHelpers",
      dependencies: []
    ),
    .target(
      name: "TCAHelpers",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
      ]
    ),
  ]
)
