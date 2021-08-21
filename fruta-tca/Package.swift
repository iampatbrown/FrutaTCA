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
    .library(name: "FavoriteSwiftUI", targets: ["FavoriteSwiftUI"]),
    .library(name: "IngredientCore", targets: ["IngredientCore"]),
    .library(name: "IngredientSwiftUI", targets: ["IngredientSwiftUI"]),
    .library(name: "NutritionFactClient", targets: ["NutritionFactClient"]),
    .library(name: "NutritionFactCore", targets: ["NutritionFactCore"]),
    .library(name: "NutritionFactFileClient", targets: ["NutritionFactFileClient"]),
    .library(name: "NutritionFactSwiftUI", targets: ["NutritionFactSwiftUI"]),
    .library(name: "OrderCore", targets: ["OrderCore"]),
    .library(name: "OrderSwiftUI", targets: ["OrderSwiftUI"]),
    .library(name: "RecipeCore", targets: ["RecipeCore"]),
    .library(name: "RecipeSwiftUI", targets: ["RecipeSwiftUI"]),
    .library(name: "RecipesCore", targets: ["RecipesCore"]),
    .library(name: "RecipesSwiftUI", targets: ["RecipesSwiftUI"]),
    .library(name: "SharedSwiftUI", targets: ["SharedSwiftUI"]),
    .library(name: "SmoothieCore", targets: ["SmoothieCore"]),
    .library(name: "SmoothieSwiftUI", targets: ["SmoothieSwiftUI"]),
    .library(name: "SmoothiesCore", targets: ["SmoothiesCore"]),
    .library(name: "SmoothiesSwiftUI", targets: ["SmoothiesSwiftUI"]),
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
        "NutritionFactClient",
        "RecipeCore",
        "RecipesCore",
        "SmoothieCore",
        "SmoothiesCore",
        "StoreKitClient",
        "StoreKitCore",
        "RecipesSwiftUI",
        "SmoothiesSwiftUI",
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
      name: "FavoriteSwiftUI",
      dependencies: [
        "FavoriteCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "IngredientCore",
      dependencies: [
        "NutritionFactCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "IngredientSwiftUI",
      dependencies: [
        "IngredientCore",
        "NutritionFactSwiftUI",
        "SharedSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [.copy("Assets.xcassets")]
    ),

    .target(
      name: "NutritionFactClient",
      dependencies: [
        "NutritionFactCore",
      ]
    ),
    .target(
      name: "NutritionFactCore",
      dependencies: [
      ]
    ),
    .target(
      name: "NutritionFactFileClient",
      dependencies: [
        "NutritionFactClient",
      ],
      resources: [.copy("NutritionFacts")]
    ),
    .target(
      name: "NutritionFactSwiftUI",
      dependencies: [
        "NutritionFactCore",
      ]
    ),
    .target(
      name: "OrderCore",
      dependencies: [
        "SmoothieCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "OrderSwiftUI",
      dependencies: [
        "OrderCore",
        "SharedSwiftUI",
        "SmoothieSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RecipeCore",
      dependencies: [
        "SmoothieCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RecipeSwiftUI",
      dependencies: [
        "IngredientCore",
        "IngredientSwiftUI",
        "RecipeCore",
        "SmoothieCore",
        "SmoothieSwiftUI",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [.copy("Assets.xcassets")]
    ),
    .target(
      name: "RecipesCore",
      dependencies: [
        "IngredientCore",
        "NutritionFactClient",
        "RecipeCore",
        "SmoothieCore",
        "StoreKitClient",
        "StoreKitCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "RecipesSwiftUI",
      dependencies: [
        "RecipeSwiftUI",
        "RecipesCore",
        "SmoothiesSwiftUI",
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
      ]
    ),
    .target(
      name: "SmoothieSwiftUI",
      dependencies: [
        "FavoriteSwiftUI",
        "IngredientCore",
        "IngredientSwiftUI",
        "SmoothieCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ],
      resources: [.process("Assets.xcassets")]
    ),
    .target(
      name: "SmoothiesCore",
      dependencies: [
        "IngredientCore",
        "NutritionFactClient",
        "NutritionFactCore",
        "SmoothieCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .target(
      name: "SmoothiesSwiftUI",
      dependencies: [
        "IngredientCore",
        "SmoothieCore",
        "SmoothieSwiftUI",
        "SmoothiesCore",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
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
