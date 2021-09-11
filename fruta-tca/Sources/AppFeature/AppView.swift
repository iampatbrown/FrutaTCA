import AccountCore
import ComposableArchitecture
import IdentifiedCollections
import RecipesFeature
import RewardsFeature
import SharedModels
import SmoothieCore
import SwiftUI
import SwiftUIHelpers

public struct AppState: Equatable {
  var account: AccountState
  var allRecipesUnlocked: Bool
  var favoritesSelection: Smoothie.ID?
  var menuSelection: Smoothie.ID?
  var navigation: AppNavigation
  var recipeSelection: Smoothie.ID?
  @BindableState var searchString: String
  var smoothies: IdentifiedArrayOf<SmoothieState>

  public init(
    account: AccountState = .guest(),
    allRecipesUnlocked: Bool = false,
    favoritesSelection: Smoothie.ID? = nil,
    menuSelection: Smoothie.ID? = nil,
    navigation: AppNavigation = .tab(current: .menu, previous: nil),
    searchString: String = "",
    smoothies: IdentifiedArrayOf<SmoothieState> = []
  ) {
    self.account = account
    self.allRecipesUnlocked = allRecipesUnlocked
    self.favoritesSelection = favoritesSelection
    self.menuSelection = menuSelection
    self.navigation = navigation
    self.searchString = searchString
    self.smoothies = smoothies
  }

  var menu: MenuState {
    get {
      MenuState(
        account: self.account,
        selection: self.menuSelection,
        searchString: self.searchString,
        smoothies: self.smoothies
      )
    }
    set {
      self.account = newValue.account
      self.menuSelection = newValue.selection
      self.searchString = newValue.searchString
      self.smoothies = newValue.smoothies
    }
  }

  var favorites: FavoritesState {
    get {
      FavoritesState(
        account: self.account,
        selection: self.favoritesSelection,
        searchString: self.searchString,
        smoothies: self.smoothies
      )
    }
    set {
      self.account = newValue.account
      self.favoritesSelection = newValue.selection
      self.searchString = newValue.searchString
      self.smoothies = newValue.smoothies
    }
  }

  var rewards: RewardsState {
    get {
      .init(account: self.account)
    }
    set {
      self.account = newValue.account
    }
  }

  var recipes: RecipeListState {
    get {
      RecipeListState(
        account: self.account,
        allRecipesUnlocked: self.allRecipesUnlocked,
        selection: self.recipeSelection,
        searchString: self.searchString,
        recipes: .init(uniqueElements: self.smoothies.map(\.toRecipeState))
      )
    }
    set {
      self.account = newValue.account
      self.recipeSelection = newValue.selection
      self.searchString = newValue.searchString
      self.smoothies = .init(uniqueElements: newValue.recipes.map(\.toSmoothieState))
    }
  }
}

public enum AppAction: Equatable, BindableAction {
  case binding(BindingAction<AppState>)
  case favorites(FavoritesAction)
  case menu(MenuAction)
  case recipes(RecipeListAction)
  case rewards(RewardsAction)
}

public struct AppEnvironment {
  public init() {}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  menuReducer.pullback(
    state: \.menu,
    action: /AppAction.menu,
    environment: { _ in }
  ),
  favoritesReducer.pullback(
    state: \.favorites,
    action: /AppAction.favorites,
    environment: { _ in }
  ),
  // TODO: rewardsReducer
  recipeListReducer.pullback(
    state: \.recipes,
    action: /AppAction.recipes,
    environment: { _ in }
  ),
  Reducer { state, action, environment in
    switch action {
    case .favorites:
      return .none

    case .menu:
      return .none

    case .recipes:
      return .none

    case .rewards:
      return .none

    case .binding:
      return .none
    }
  }
).binding()

public struct AppView: View {
  let store: Store<AppState, AppAction>

  struct ViewState: Equatable {
    @BindableState var navigationStyle: AppNavigation.Style

    init(state: AppState) {
      self.navigationStyle = state.navigation.style
    }
  }

  enum ViewAction: BindableAction {
    case binding(BindingAction<ViewState>)
  }

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init, action: ViewAction.to(appAction:))) { viewStore in
      AppNavigationView(store: self.store, style: viewStore.navigationStyle)
        .assign(environment: \.navigationStyle, to: viewStore.$navigationStyle)
    }
  }
}

extension AppState {
  var view: AppView.ViewState {
    get { .init(state: self) }
    set {
      guard self.navigation.style != newValue.navigationStyle else { return }
      self.navigation.toggle()
    }
  }
}

extension AppView.ViewAction {
  static func to(appAction action: Self) -> AppAction {
    switch action {
    case let .binding(bindingAction):
      return .binding(bindingAction.pullback(\AppState.view))
    }
  }
}

extension EnvironmentValues {
  var navigationStyle: AppNavigation.Style {
    #if os(iOS)
    if horizontalSizeClass == .compact { return .tab }
    #endif
    return .sidebar
  }
}

extension AppState {
  public static let mock = Self(
    smoothies: .mock
  )
}
