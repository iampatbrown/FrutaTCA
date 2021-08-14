import ComposableArchitecture
import Foundation
import IngredientCore
import NutritionFactClient
import RecipeCore
import SmoothieCore
import StoreKit
import StoreKitClient
import StoreKitCore

public struct RecipesState: Equatable {
  public var recipes: IdentifiedArrayOf<RecipeState>
  public var selection: Smoothie.ID?
  public var searchQuery: String
  public var store: StoreKitState

  public init(
    recipes: IdentifiedArrayOf<RecipeState> = .init(Smoothie.allSorted()),
    selection: Smoothie.ID? = nil,
    searchQuery: String = "",
    store: StoreKitState = StoreKitState(allProductIdentifiers: [RecipesState.unlockAllRecipesIdentifier])
  ) {
    self.recipes = recipes
    self.selection = selection
    self.searchQuery = searchQuery
    self.store = store
  }

  public var allRecipesUnlocked: Bool { store.allRecipesUnlocked }

  public var listedRecipes: IdentifiedArrayOf<RecipeState> {
    if allRecipesUnlocked {
      return recipes.filter { $0.smoothie.matches(searchQuery) }
    } else {
      let freeRecipeIDs: [Smoothie.ID] = [Smoothie.berryBlue.id, Smoothie.carrotChops.id, Smoothie.thatsBerryBananas.id]
      return recipes.filter { freeRecipeIDs.contains($0.id) && $0.smoothie.matches(searchQuery) }
    }
  }

  public var searchSuggestions: [Ingredient] { Ingredient.suggestions(for: searchQuery) }

  public var unlockAllRecipesProduct: Product? {
    store.fetchedProducts.first { $0.id == RecipesState.unlockAllRecipesIdentifier }
  }

  public static let unlockAllRecipesIdentifier = "dev.patbrown.fruta-tca.unlock-recipes"
}

public enum RecipesAction: Equatable {
  case onAppear
  case recipe(id: Smoothie.ID, action: RecipeAction)
  case searchQueryChanged(String)
  case setRecipe(selection: Smoothie.ID?)
  case store(StoreKitAction)
}

public struct RecipesEnvironment {
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var nutritionFacts: NutritionFactClient
  public var storeKit: StoreKitClient

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    nutritionFacts: NutritionFactClient,
    storeKit: StoreKitClient
  ) {
    self.mainQueue = mainQueue
    self.nutritionFacts = nutritionFacts
    self.storeKit = storeKit
  }
}

public let recipesReducer = Reducer<RecipesState, RecipesAction, RecipesEnvironment>.combine(
  storeKitReducer.pullback(
    state: \.store,
    action: /RecipesAction.store,
    environment: { StoreKitEnvironment(mainQueue: $0.mainQueue, storeKit: $0.storeKit) }
  ),

  recipeReducer.forEach(
    state:
    \.recipes,
    action: /RecipesAction.recipe(id:action:),
    environment: { _ in RecipeEnvironment() }
  ),

  Reducer { state, action, environment in
    switch action {
    case .onAppear:
      for recipe in state.recipes where recipe.smoothie.nutritionFact == nil {
        state.recipes[id: recipe.id]?.smoothie.loadNutritionFact(from: environment.nutritionFacts)
      }
      return Effect(value: .store(.onAppear))

    case .recipe:
      return .none

    case let .searchQueryChanged(searchQuery):
      state.searchQuery = searchQuery
      return .none

    case let .setRecipe(selection):
      state.selection = selection
      return .none

    case .store:
      return .none
    }
  }
)

extension IdentifiedArray where Element == RecipeState, ID == Smoothie.ID {
  public init(_ smoothies: [Smoothie]) {
    self.init(uniqueElements: smoothies.map { .init(smoothie: $0) })
  }
}
