import ComposableArchitecture
import FavoriteCore
import IngredientCore
import NutritionFactClient
import NutritionFactCore

public struct SmoothieState: Equatable, Identifiable {
  public var smoothie: Smoothie

  public var selectedIngredientID: Ingredient.ID?
  public var isFavorite: Bool

  public init(
    smoothie: Smoothie,
    selectedIngredientID: Ingredient.ID? = nil,
    isFavorite: Bool = false
  ) {
    self.smoothie = smoothie
    self.selectedIngredientID = selectedIngredientID
    self.isFavorite = isFavorite
  }

  public var id: Smoothie.ID { smoothie.id }

  public var favorite: FavoriteState<ID> {
    get { .init(id: self.id, isFavorite: self.isFavorite) }
    set { self.isFavorite = newValue.isFavorite }
  }
}

public enum SmoothieAction: Equatable {
  case setIngredient(selection: Ingredient.ID?)
  case onAppear
  case favorite(FavoriteAction)
}

public struct SmoothieEnvironment {
  public init(nutritionFacts: NutritionFactClient) {
    self.nutritionFacts = nutritionFacts
  }

  public var nutritionFacts: NutritionFactClient
}

public let smoothieReducer = Reducer<SmoothieState, SmoothieAction, SmoothieEnvironment> { state, action, environment in
  switch action {
  case let .setIngredient(id):
    state.selectedIngredientID = id
    return .none
  case .favorite:
    return .none
  case .onAppear:
    state.selectedIngredientID = nil // TODO: Just doing this to reset IngredientCards
    guard state.smoothie.nutritionFact == nil else { return .none }
    state.smoothie.loadNutritionFact(from: environment.nutritionFacts)
    return .none
  }
}.favorite(
  state: \.favorite,
  action: /SmoothieAction.favorite,
  environment: { _ in FavoriteEnvironment() }
)

extension Smoothie {
  public mutating func loadNutritionFact(from nutritionFacts: NutritionFactClient) {
    for i in 0 ..< measuredIngredients.count {
      let nutritionFact = nutritionFacts.lookupFoodItem(measuredIngredients[i].id)
      measuredIngredients[i].ingredient.nutritionFact = nutritionFact
    }
  }
}
