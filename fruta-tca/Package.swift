// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "fruta-tca",
  platforms: [.macOS(.v12), .iOS(.v15)],
  products: [
    .library(name: "AccountCore", targets: ["AccountCore"]),
    .library(name: "AppFeature", targets: ["AppFeature"]),
    .library(name: "AuthenticationClient", targets: ["AuthenticationClient"]),
    .library(name: "FavoriteCore", targets: ["FavoriteCore"]),
    .library(name: "FavoritesFeature", targets: ["FavoritesFeature"]),
    .library(name: "IngredientCore", targets: ["IngredientCore"]),
    .library(name: "MenuFeature", targets: ["MenuFeature"]),
    .library(name: "NutritionFactClient", targets: ["NutritionFactClient"]),
    .library(name: "NutritionFactCore", targets: ["NutritionFactCore"]),
    .library(name: "OrderCore", targets: ["OrderCore"]),
    .library(name: "RecipesFeature", targets: ["RecipesFeature"]),
    .library(name: "SharedSwiftUI", targets: ["SharedSwiftUI"]),
    .library(name: "SmoothieCore", targets: ["SmoothieCore"]),
    .library(name: "StoreKitClient", targets: ["StoreKitClient"]),
    .library(name: "StoreKitCore", targets: ["StoreKitCore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", .branch("main")),
  ],
  targets: [
    .target(
      name: "AccountCore",
      dependencies: [
        "AuthenticationClient",
        "OrderCore",
        "SharedSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "AppFeature",
      dependencies: [
        "AccountCore",
        "AuthenticationClient",
        "FavoritesFeature",
        "NutritionFactClient",
        "RecipesFeature",
        "MenuFeature",
        "StoreKitClient",
        "StoreKitCore",
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
      name: "FavoriteCore",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "FavoritesFeature",
      dependencies: [
        "SmoothieCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "IngredientCore",
      dependencies: [
        "NutritionFactCore",
        "SharedSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [.copy("Assets.xcassets")]
    ),
    .target(
      name: "MenuFeature",
      dependencies: [
        "SmoothieCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "NutritionFactClient",
      dependencies: [
        "NutritionFactCore",
      ],
      resources: [.copy("NutritionFacts")]
    ),
    .target(
      name: "NutritionFactCore",
      dependencies: [      ]
    ),
    .target(
      name: "OrderCore",
      dependencies: [
        "SmoothieCore",
        "SharedSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RecipesFeature",
      dependencies: [
        "IngredientCore",
        "NutritionFactClient",
        "SmoothieCore",
        "StoreKitClient",
        "StoreKitCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [.copy("Assets.xcassets")]
    ),
    .target(
      name: "SharedSwiftUI",
      dependencies: [],
      resources: [.copy("Assets.xcassets")]
    ),
    .target(
      name: "SmoothieCore",
      dependencies: [
        "FavoriteCore",
        "IngredientCore",
        "NutritionFactClient",
        "NutritionFactCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [.process("Assets.xcassets")]
    ),
    .target(
      name: "StoreKitClient",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "StoreKitCore",
      dependencies: [
        "StoreKitClient",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
  ]
)
