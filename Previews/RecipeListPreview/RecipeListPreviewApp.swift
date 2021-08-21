import ComposableArchitecture
import NutritionFactClient
import RecipeCore
import RecipesCore
import RecipesSwiftUI
import RecipeSwiftUI
import SwiftUI

@main
struct RecipeListPreviewApp: App {
  let store = Store(
    initialState: RecipesState(),
    reducer: recipesReducer,
    environment: RecipesEnvironment(mainQueue: .main, nutritionFacts: .live, storeKit: .live)
  )

  var body: some Scene {
    WindowGroup {
      NavigationView {
        RecipeList(store: store)
      }
    }
  }
}
