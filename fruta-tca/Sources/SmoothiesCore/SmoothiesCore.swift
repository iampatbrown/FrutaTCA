import ComposableArchitecture
import IngredientCore
import NutritionFactClient
import SmoothieCore

public struct SmoothiesState: Equatable {
  public var smoothies: IdentifiedArrayOf<SmoothieState>
  public var selection: Smoothie.ID?
  public var searchQuery: String

  public init(
    smoothies: IdentifiedArrayOf<SmoothieState> = IdentifiedArrayOf<SmoothieState>(
      uniqueElements: Smoothie.all()
        .sorted(by: { $0.title.localizedCompare($1.title) == .orderedAscending })
        .map { SmoothieState(smoothie: $0) }
    ),
    selection: Smoothie.ID? = nil,
    searchQuery: String = ""
  ) {
    self.smoothies = smoothies
    self.selection = selection
    self.searchQuery = searchQuery
  }

  public var listedSmoothies: IdentifiedArrayOf<SmoothieState> {
    smoothies.filter { $0.smoothie.matches(searchQuery) }
  }

  public var searchSuggestions: [Ingredient] {
    Ingredient.all
      .filter {
        $0.name.localizedCaseInsensitiveContains(searchQuery) &&
          $0.name.localizedCaseInsensitiveCompare(searchQuery) != .orderedSame
      }
  }

  public var favoriteSmoothies: IdentifiedArrayOf<SmoothieState> {
    smoothies.filter(\.isFavorite)
  }
}

public enum SmoothiesAction: Equatable {
  case setSmoothie(selection: Smoothie.ID?)
  case searchQueryChanged(String)
  case smoothie(id: Smoothie.ID, action: SmoothieAction)
}

public struct SmoothiesEnvironment {
  public init(nutritionFacts: NutritionFactClient) {
    self.nutritionFacts = nutritionFacts
  }

  public var nutritionFacts: NutritionFactClient
}

public let smoothiesReducer = Reducer<
  SmoothiesState,
  SmoothiesAction,
  SmoothiesEnvironment
>.combine(
  smoothieReducer.forEach(
    state: \.smoothies,
    action: /SmoothiesAction.smoothie(id:action:),
    environment: { SmoothieEnvironment(nutritionFacts: $0.nutritionFacts) }
  ),
  Reducer { state, action, environment in
    switch action {
    case let .setSmoothie(selection):
      state.selection = selection
      return .none

    case let .searchQueryChanged(searchQuery):
      state.searchQuery = searchQuery
      return .none

    case .smoothie:
      return .none
    }
  }
)

extension IdentifiedArray where Element == SmoothieState, ID == Smoothie.ID {
  public init(_ smoothies: [Smoothie]) {
    self.init(uniqueElements: smoothies.map { .init(smoothie: $0) })
  }
}
