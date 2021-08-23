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
  public var route: Tab
  public var searchString: String
  public var unlockAllRecipesProduct: Product?

  public init(
    account: Account? = nil,
    allRecipesUnlocked: Bool = false,
    favoriteSmoothieIDs: Set<Smoothie.ID> = [],
    order: Order? = nil,
    route: Tab = .menu,
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

  public enum Tab: Equatable {
    case menu
    case favorites
    case rewards
    case recipes
  }
}

public enum AppAction: Equatable {
  case addOrderToAccount
  case clearUnstampedPoints
  case createAccount
  case onAppear
  case orderSmoothie(Smoothie)
  case redeemSmoothie(Smoothie)
  case searchStringChanged(String)
  case toggleFavorite(Smoothie)
  case setNavigation(AppState.Tab)

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
    case let .orderSmoothie(smoothie):
      state.order = Order(smoothie: smoothie, points: 1, isReady: false)
      return Effect(value: .addOrderToAccount)

    case let .redeemSmoothie(smoothie):
      guard var account = state.account, account.canRedeemFreeSmoothie else { return .none }
      account.pointsSpent += 10
      state.account = account
      return Effect(value: .orderSmoothie(smoothie))

    case let .toggleFavorite(smoothie):
      if state.favoriteSmoothieIDs.contains(smoothie.id) {
        state.favoriteSmoothieIDs.remove(smoothie.id)
      } else {
        state.favoriteSmoothieIDs.insert(smoothie.id)
      }
      return .none

    case .clearUnstampedPoints:
      state.account?.clearUnstampedPoints()
      return .none

    case .addOrderToAccount:
      guard let order = state.order else { return .none }
      state.account?.appendOrder(order)
      return .none

    case .createAccount:
      guard state.account == nil else { return .none }
      state.account = Account()
      return Effect(value: .addOrderToAccount)

    case let .searchStringChanged(searchString):
      state.searchString = searchString
      return .none
    case .onAppear:
      return .none

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

  struct ViewState: Equatable {
    var route: AppState.Tab

    init(state: AppState) {
      self.route = state.route
    }
  }

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init)) { viewStore in
      TabView(
        selection: viewStore.binding(
          get: \.route,
          send: AppAction.setNavigation
        )
      ) {
        NavigationView {
          SmoothieMenu(store: self.store.scope(state: \.menu, action: AppAction.menu))
        }
        .tabItem {
          let menuText = Text("Menu", comment: "Smoothie menu tab title")
          Label {
            menuText
          } icon: {
            Image(systemName: "list.bullet")
          }.accessibility(label: menuText)
        }
        .tag(AppState.Tab.menu)

        NavigationView {
          FavoriteSmoothies(store: self.store.scope(state: \.favorites, action: AppAction.favorites))
        }
        .tabItem {
          Label {
            Text(
              "Favorites",
              comment: "Favorite smoothies tab title"
            )
          } icon: {
            Image(systemName: "heart.fill")
          }
        }
        .tag(AppState.Tab.favorites)

        NavigationView {
          RewardsView(store: self.store.scope(state: \.rewards, action: AppAction.rewards))
        }
        .tabItem {
          Label {
            Text(
              "Rewards",
              comment: "Smoothie rewards tab title"
            )
          } icon: {
            Image(systemName: "seal.fill")
          }
        }
        .tag(AppState.Tab.rewards)

        NavigationView {
          RecipeList(store: self.store.scope(state: \.recipes, action: AppAction.recipes))
        }
        .tabItem {
          Label {
            Text(
              "Recipes",
              comment: "Smoothie recipes tab title"
            )
          } icon: {
            Image(systemName: "book.closed.fill")
          }
        }
        .tag(AppState.Tab.recipes)

      }.navigationViewStyle(.stack)
        .onAppear { viewStore.send(.recipes(.store(.onLaunch))) }
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
