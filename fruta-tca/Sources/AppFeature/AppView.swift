import AuthenticationClient
import ComposableArchitecture
import OrdersFeature
import RecipesFeature
import SharedModels
import SmoothiesCore
import StoreKit
import StoreKitClient
import SwiftUI

public struct AppState: Equatable {
  public var account: Account?
  public var allRecipesUnlocked: Bool
  public var favoriteSmoothieIDs: Set<Smoothie.ID>
  public var order: Order?
  public var route: Route
  public var searchString: String
  public var unlockAllRecipesProduct: Product?

  public init(
    account: Account? = nil,
    allRecipesUnlocked: Bool = false,
    favoriteSmoothieIDs: Set<Smoothie.ID> = [],
    order: Order? = nil,
    route: Route = .tab(.menu),
    searchString: String = "",
    store: StoreKitState = .init(),
    unlockAllRecipesProduct: Product? = nil
  ) {
    self.account = account
    self.allRecipesUnlocked = allRecipesUnlocked
    self.favoriteSmoothieIDs = favoriteSmoothieIDs
    self.order = order
    self.route = route
    self.searchString = searchString
    self.store = store
    self.unlockAllRecipesProduct = unlockAllRecipesProduct
  }

  private var menuSelection: SmoothieState?
  public var menu: SmoothieListState {
    get {
      .init(
        account: self.account,
        order: self.order,
        selection: self.menuSelection,
        searchString: self.searchString,
        favoriteSmoothieIDs: self.favoriteSmoothieIDs
      )
    }
    set {
      self.account = newValue.account
      self.order = newValue.order
      self.menuSelection = newValue.selection
      self.searchString = newValue.searchString
      self.favoriteSmoothieIDs = newValue.favoriteSmoothieIDs
    }
  }

  private var favoritesSelection: SmoothieState?
  public var favorites: SmoothieListState {
    get {
      .init(
        account: self.account,
        order: self.order,
        selection: self.favoritesSelection,
        searchString: self.searchString,
        favoriteSmoothieIDs: self.favoriteSmoothieIDs,
        filterFavorites: true
      )
    }
    set {
      self.account = newValue.account
      self.order = newValue.order
      self.favoritesSelection = newValue.selection
      self.searchString = newValue.searchString
      self.favoriteSmoothieIDs = newValue.favoriteSmoothieIDs
    }
  }

  public var rewards: RewardsState {
    get { .init(account: self.account) }
    set { self.account = newValue.account }
  }

  private var recipesSelection: Smoothie.ID?
  public var store: StoreKitState
  public var recipes: RecipeListState {
    get {
      .init(
        account: self.account,
        favoriteSmoothieIDs: self.favoriteSmoothieIDs,
        searchString: self.searchString,
        selection: self.recipesSelection,
        store: self.store
      )
    }
    set {
      self.account = newValue.account
      self.favoriteSmoothieIDs = newValue.favoriteSmoothieIDs
      self.recipesSelection = newValue.selection
      self.searchString = newValue.searchString
      self.store = newValue.store
    }
  }

  public enum Route: Equatable {
    case tab(Tab)
    case sidebar(SidebarItem?)

    public enum Tab: Equatable {
      case menu
      case favorites
      case rewards
      case recipes
    }

    public enum SidebarItem: Equatable {
      case menu
      case favorites
      case recipes
    }
  }
}

public enum AppAction: Equatable {
  case setNavigation(AppState.Route)
  case menu(SmoothieListAction)
  case favorites(SmoothieListAction)
  case rewards(RewardsAction)
  case recipes(RecipeListAction)
}

public struct AppEnvironment {
  public var authentication: AuthenticationClient
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var storeKit: StoreKitClient

  public init(
    authentication: AuthenticationClient,
    mainQueue: AnySchedulerOf<DispatchQueue>,
    storeKit: StoreKitClient
  ) {
    self.authentication = authentication
    self.mainQueue = mainQueue
    self.storeKit = storeKit
  }
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
  smoothiesReducer.pullback(
    state: \.menu,
    action: /AppAction.menu,
    environment: { .init(authentication: $0.authentication) }
  ),
  smoothiesReducer.pullback(
    state: \.favorites,
    action: /AppAction.favorites,
    environment: { .init(authentication: $0.authentication) }
  ),
  rewardsReducer.pullback(
    state: \.rewards,
    action: /AppAction.rewards,
    environment: { .init(authentication: $0.authentication) }
  ),
  recipesReducer.pullback(
    state: \.recipes,
    action: /AppAction.recipes,
    environment: { .init(storeKit: $0.storeKit) }
  ),
  Reducer {
    state, action, environment in
    switch action {
    case let .setNavigation(route):
      state.route = route
      return .none

    case .menu:
      return .none

    case .favorites:
      return .none

    case .rewards:
      return .none

    case .recipes:
      return .none
    }
  }
)

public struct AppView: View {
  let store: Store<AppState, AppAction>

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  #if os(iOS)
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
  #endif

  public var body: some View {
    Group {
      #if os(iOS)
        if horizontalSizeClass == .compact {
          AppTabNavigation(store: store)
        } else {
          AppSidebarNavigation(store: store)
        }
      #else
        AppSidebarNavigation(store: store)
      #endif
    }
    .onAppear {
      ViewStore(store.stateless).send(.recipes(.store(.onLaunch)))
      // TODO: confirm this can't get called multiple times otherwise use appDelegate
    }

  }
}

struct AppView_Previews: PreviewProvider {
  static var previews: some View {
    AppView(store: Store(
      initialState: .init(),
      reducer: appReducer,
      environment: .init(authentication: .mock, mainQueue: .main, storeKit: .mock)
    ))
  }
}
