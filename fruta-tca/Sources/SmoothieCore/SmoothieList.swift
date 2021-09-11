import AccountCore
import ComposableArchitecture
import SharedModels
import SwiftUI
import TCAHelpers

public struct SmoothieListState: Equatable {
  public var account: AccountState
  @BindableState public var searchString: String
  @BindableState public var selection: Smoothie.ID?
  public var smoothies: IdentifiedArrayOf<SmoothieState>

  public init(
    account: AccountState = .guest(),
    selection: Smoothie.ID? = nil,
    searchString: String = "",
    smoothies: IdentifiedArrayOf<SmoothieState> = .mock
  ) {
    self.account = account
    self.searchString = searchString
    self.selection = selection
    self.smoothies = smoothies
  }

  var listedSmoothies: IdentifiedArrayOf<SmoothieState> {
    smoothies
      .filter { $0.matches(searchString) }
      .sorted(by: { $0.title.localizedCompare($1.title) == .orderedAscending })
  }
}

public enum SmoothieListAction: Equatable, BindableAction {
  case binding(BindingAction<SmoothieListState>)
  case smoothie(id: Smoothie.ID, action: SmoothieAction)
}

public let smoothieListReducer = Reducer<SmoothieListState, SmoothieListAction, Void>.combine(
  smoothieReducer.forEach(
    state: \.smoothies,
    action: /SmoothieListAction.smoothie,
    environment: { $0 }
  ),
  Reducer { state, action, _ in
    return .none
  }
).binding()

public struct SmoothieList: View {
  let store: Store<SmoothieListState, SmoothieListAction>

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
        ForEachStore(
          self.store.scope(state: \.smoothies, action: SmoothieListAction.smoothie(id:action:))
        ) { childStore in
          SmoothieNavigationLink(store: childStore, selection: viewStore.$selection)
        }
      }.searchable(text: viewStore.$searchString) {
        Text(viewStore.searchString)
//        ForEach(viewStore.searchSuggestions) { ... }
      }
    }
  }
}

extension SmoothieState {
  public func matches(_ searchString: String) -> Bool {
    searchString.isEmpty ||
      title.localizedCaseInsensitiveContains(searchString) ||
      menuIngredients.contains {
        $0.ingredient.name.localizedCaseInsensitiveContains(searchString)
      }
  }
}

extension IdentifiedArray where ID == Smoothie.ID, Element == SmoothieState {
  public static let mock: Self = [
    SmoothieState(
      id: "berry-blue",
      title: "Berry Blue",
      description: "*Filling* and *refreshing*, this smoothie will fill you with joy!",
      measuredIngredients: [],
      hasFreeRecipe: true,
      isFavorite: false,
      energy: .init(value: 5, unit: .kilocalories)
    ),
    SmoothieState(
      id: "one-in-a-melon",
      title: "One in a Melon",
      description: "Feel special this summer with the *coolest* drink in our menu!",
      measuredIngredients: [],
      hasFreeRecipe: false,
      isFavorite: false,
      energy: .init(value: 4, unit: .kilocalories)
    ),
    SmoothieState(
      id: "lemonberry",
      title: "Lemonberry",
      description: "A refreshing blend that's a *real kick*!",
      measuredIngredients: [],
      hasFreeRecipe: true,
      isFavorite: false,
      energy: .init(value: 3, unit: .kilocalories)
    ),
  ]
}
