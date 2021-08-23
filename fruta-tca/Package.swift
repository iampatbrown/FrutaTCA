// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "fruta-tca",
  defaultLocalization: "en",
  platforms: [.macOS(.v12), .iOS(.v15)],
  products: [
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AuthenticationClient", targets: ["AuthenticationClient"]),
    .library(name: "OrdersFeature", targets: ["OrdersFeature"]),
    .library(name: "RecipesFeature", targets: ["RecipesFeature"]),
    .library(name: "SmoothiesCore", targets: ["SmoothiesCore"]),
    .library(name: "SharedModels", targets: ["SharedModels"]),
    .library(name: "SharedUI", targets: ["SharedUI"]),
    .library(name: "StoreKitClient", targets: ["StoreKitClient"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .branch("main")),
  ],
  targets: [
    .target(
      name: "AppFeature",
      dependencies: [
        "OrdersFeature",
        "RecipesFeature",
        "SharedModels",
        "SmoothiesCore",
        "StoreKitClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AuthenticationClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "OrdersFeature",
      dependencies: [
        "AuthenticationClient",
        "SharedModels",
        "SharedUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RecipesFeature",
      dependencies: [
        "SharedModels",
        "SharedUI",
        "SmoothiesCore",
        "StoreKitClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SharedModels",
      dependencies: [],
      resources: [.process("Resources/")]
    ),
    .target(
      name: "SharedUI",
      dependencies: [
        "SharedModels",
      ]
    ),
    .target(
      name: "SmoothiesCore",
      dependencies: [
        "AuthenticationClient",
        "SharedModels",
        "SharedUI",
        "OrdersFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "StoreKitClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
  ]
)
