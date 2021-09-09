import ComposableArchitecture
import EnvironmentPullback
import SwiftUI

public struct AppState: Equatable {
  var navigation: AppNavigation

  public init(
    navigation: AppNavigation = .sidebar(selection: .menu, isPresentingRewards: false)
  ) {
    self.navigation = navigation
  }
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
    WithViewStore(self.store.scope(state: ViewState.init, action: AppAction.init)) { viewStore in
      Group {
        if viewStore.navigationStyle == .tab {
          AppTabNavigationView(store: self.store)
        } else {
          AppSidebarNavigationView(store: self.store)
        }
      }
      .environmentPullback(to: viewStore.$navigationStyle, values: \.toAppNavigationStyle)
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

extension AppAction {
  init(action: AppView.ViewAction) {
    switch action {
    case let .binding(bindingAction):
      self = .binding(bindingAction.pullback(\AppState.view))
    }
  }
}

extension EnvironmentValues {
  var toAppNavigationStyle: AppNavigation.Style {
    #if os(iOS)
    if horizontalSizeClass == .compact { return .tab }
    #endif
    return .sidebar
  }
}
