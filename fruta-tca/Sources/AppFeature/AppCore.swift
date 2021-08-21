import AccountCore
import AuthenticationClient
import ComposableArchitecture
import NutritionFactClient
import RecipesFeature
import SmoothieCore
import SmoothiesCore
import StoreKitClient
import StoreKitCore

public struct AppState: Equatable {
  public var smoothies: IdentifiedArrayOf<SmoothieState>
  public var searchQuery: String
  public var navigation: TabNavigationState

  private var menuSelection: Smoothie.ID?
  public var menu: SmoothiesState {
    get {
      SmoothiesState(
        smoothies: self.smoothies,
        selection: self.menuSelection,
        searchQuery: self.searchQuery
      )
    }
    set {
      self.smoothies = newValue.smoothies
      self.menuSelection = newValue.selection
      self.searchQuery = newValue.searchQuery
    }
  }

  private var favoritesSelection: Smoothie.ID?
  public var favorites: SmoothiesState {
    get {
      SmoothiesState(
        smoothies: self.smoothies,
        selection: self.favoritesSelection,
        searchQuery: self.searchQuery
      )
    }
    set {
      self.smoothies = newValue.smoothies
      self.favoritesSelection = newValue.selection
      self.searchQuery = newValue.searchQuery
    }
  }

  public var account: AccountState?

  private var _recipes: IdentifiedArrayOf<RecipeState>?
  private var recipesSelection: Smoothie.ID?
  private var allRecipesUnlocked: Bool = false

  public var store: StoreKitState

  public var recipes: RecipesState {
    get {
      RecipesState(
        recipes: self._recipes ?? .init(self.smoothies.map(\.smoothie)),
        selection: self.recipesSelection,
        searchQuery: self.searchQuery,
        store: self.store
      )
    }
    set {
      self._recipes = newValue.recipes
      self.recipesSelection = newValue.selection
      self.store = newValue.store
      self.searchQuery = newValue.searchQuery
    }
  }

  public init(
    account: AccountState? = nil,
    allRecipesUnlocked: Bool = false,
    favoritesSelection: Smoothie.ID? = nil,
    menuSelection: Smoothie.ID? = nil,
    navigation: TabNavigationState = .init(),
    recipesSelection: Smoothie.ID? = nil,
    searchQuery: String = "",
    smoothies: IdentifiedArrayOf<SmoothieState> = .init(Smoothie.allSorted()),
    store: StoreKitState = StoreKitState(allProductIdentifiers: [RecipesState.unlockAllRecipesIdentifier])
  ) {
    self.account = account
    self.allRecipesUnlocked = allRecipesUnlocked
    self.favoritesSelection = favoritesSelection
    self.menuSelection = menuSelection
    self.navigation = navigation
    self.recipesSelection = recipesSelection
    self.searchQuery = searchQuery
    self.smoothies = smoothies
    self.store = store
  }
}

public enum AppAction: Equatable {
  case favorites(SmoothiesAction)
  case menu(SmoothiesAction)
  case navigation(TabNavigationAction)
  case recipes(RecipesAction)
  case rewards(AccountAction)
}

public struct AppEnvironment {
  public var authenticationClient: AuthenticationClient
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var nutritionFacts: NutritionFactClient
  public var storeKit: StoreKitClient

  public init(
    authenticationClient: AuthenticationClient,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    nutritionFacts: NutritionFactClient,
    storeKit: StoreKitClient
  ) {
    self.authenticationClient = authenticationClient
    self.mainQueue = mainQueue
    self.nutritionFacts = nutritionFacts
    self.storeKit = storeKit
  }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  tabNavigationReducer.pullback(
    state: \.navigation,
    action: /AppAction.navigation,
    environment: { _ in }
  ),

  smoothiesReducer.pullback(
    state: \.menu,
    action: /AppAction.menu,
    environment: {
      .init(nutritionFacts: $0.nutritionFacts)
    }
  ),

  smoothiesReducer.pullback(
    state: \.favorites,
    action: /AppAction.favorites,
    environment: {
      .init(nutritionFacts: $0.nutritionFacts)
    }
  ),

  accountReducer.pullback(
    state: \.account,
    action: /AppAction.rewards,
    environment: { .init(authenticationClient: $0.authenticationClient) }
  ),

  recipesReducer.pullback(
    state: \.recipes,
    action: /AppAction.recipes,
    environment: { .init(
      mainQueue: $0.mainQueue,
      nutritionFacts: $0.nutritionFacts,
      storeKit: $0.storeKit
    ) }
  ),

  Reducer { state, action, environment in
    return .none
  }
)
