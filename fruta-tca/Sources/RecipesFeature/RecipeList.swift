import AccountCore
import ComposableArchitecture
import SharedModels
import SmoothieCore
import SwiftUI

public struct RecipeListState: Equatable {
  public var account: AccountState
  public var allRecipesUnlocked: Bool
  @BindableState public var searchString: String
  @BindableState public var selection: Smoothie.ID?
  public var recipes: IdentifiedArrayOf<RecipeState>

  public init(
    account: AccountState = .guest(),
    allRecipesUnlocked: Bool = false,
    selection: Smoothie.ID? = nil,
    searchString: String = "",
    recipes: IdentifiedArrayOf<RecipeState> = .mock
  ) {
    self.account = account
    self.allRecipesUnlocked = allRecipesUnlocked
    self.searchString = searchString
    self.selection = selection
    self.recipes = recipes
  }

  var listedRecipes: IdentifiedArrayOf<RecipeState> {
    recipes
      .filter { $0.matches(searchString) }
      .filter { allRecipesUnlocked || $0.hasFreeRecipe }
      .sorted(by: { $0.title.localizedCompare($1.title) == .orderedAscending })
  }
}

public enum RecipeListAction: Equatable, BindableAction {
  case binding(BindingAction<RecipeListState>)
  case smoothie(id: Smoothie.ID, action: RecipeAction)
}


public let recipeListReducer = Reducer<RecipeListState, RecipeListAction, Void>.combine(
  recipeReducer.forEach(
    state: \.recipes,
    action: /RecipeListAction.smoothie,
    environment: { $0 }
  ),
  Reducer { state, action, _ in
    return .none
  }
).binding()



public struct RecipeList: View {
  let store: Store<RecipeListState, RecipeListAction>

  public init(store: Store<RecipeListState, RecipeListAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
        #if os(iOS)
        if !viewStore.allRecipesUnlocked {
          Section {
            Text("Unlock Button")
          }
        }
        #endif
        ForEachStore(
          self.store.scope(state: \.listedRecipes, action: RecipeListAction.smoothie(id:action:))
        ) { childStore in
          RecipeNavigationLink(store: childStore, selection: viewStore.$selection)
        }
      }
      .navigationTitle(Text("Recipes"))
      .searchable(text: viewStore.$searchString) {
        Text(viewStore.searchString)
//        ForEach(viewStore.searchSuggestions) { ... }
      }
    }
  }
}

extension RecipeState {
  public func matches(_ searchString: String) -> Bool {
    searchString.isEmpty ||
      title.localizedCaseInsensitiveContains(searchString) ||
      menuIngredients.contains {
        $0.ingredient.name.localizedCaseInsensitiveContains(searchString)
      }
  }
}

extension IdentifiedArray where ID == Smoothie.ID, Element == RecipeState {
  public static let mock: Self = [
    RecipeState(
      id: "berry-blue",
      title: "Berry Blue",
      description: "*Filling* and *refreshing*, this smoothie will fill you with joy!",
      measuredIngredients: [],
      hasFreeRecipe: true,
      isFavorite: false,
      smoothieCount: 1,
      energy: .init(value: 5, unit: .kilocalories)
    ),
    RecipeState(
      id: "one-in-a-melon",
      title: "One in a Melon",
      description: "Feel special this summer with the *coolest* drink in our menu!",
      measuredIngredients: [],
      hasFreeRecipe: false,
      isFavorite: false,
      smoothieCount: 1,
      energy: .init(value: 4, unit: .kilocalories)
    ),
    RecipeState(
      id: "lemonberry",
      title: "Lemonberry",
      description: "A refreshing blend that's a *real kick*!",
      measuredIngredients: [],
      hasFreeRecipe: true,
      isFavorite: false,
      smoothieCount: 1,
      energy: .init(value: 3, unit: .kilocalories)
    ),
  ]
}
