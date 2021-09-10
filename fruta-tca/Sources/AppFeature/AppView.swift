import ComposableArchitecture
import IdentifiedCollections
import SmoothieCore
import SwiftUI
import SwiftUIHelpers

public struct AppState: Equatable {
  var navigation: AppNavigation
  var smoothies: IdentifiedArrayOf<SmoothieState>
  @BindableState var searchString: String

  public init(
    navigation: AppNavigation = .sidebar(selection: nil, isPresentingRewards: false),
    searchString: String = "",
    smoothies: IdentifiedArrayOf<SmoothieState> = []
  ) {
    self.navigation = navigation
    self.searchString = searchString
    self.smoothies = smoothies
  }

  var menu: String = ""
  // Account
  // Search
  // SmoothieState
  // Unique Selection.ID

  var favorites: String = ""
  // Account
  // Search
  // SmoothieState ---> Filtered.isFavorites
  // Unique Selection.ID

  var rewards: String = ""
  // Account

  var recipes: String = ""
  // Search
  // SmoothieState ---> RecipeState
  // Toggle Favorite
  // Unique Selection.ID
  // StoreIntegration
}

public enum AppAction: Equatable, BindableAction {
  case binding(BindingAction<AppState>)
}

public struct AppEnvironment {
  public init() {}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
  switch action {
  case .binding:
    return .none
  }
}.binding()

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
        .assign(environment: \.toNavigationStyle, to: viewStore.$navigationStyle)
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
  var toNavigationStyle: AppNavigation.Style {
    #if os(iOS)
    if horizontalSizeClass == .compact { return .tab }
    #endif
    return .sidebar
  }
}
