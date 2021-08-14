import ComposableArchitecture
import Foundation

public struct TabNavigationState: Equatable {
  public var route: Route

  public init(
    route: TabNavigationState.Route = .menu
  ) {
    self.route = route
  }

  public enum Route: Equatable {
    case menu
    case favorites
    case rewards
    case recipes

    public enum Tag: Int {
      case menu
      case favorites
      case rewards
      case recipes
    }

    public var tag: Tag {
      switch self {
      case .menu: return .menu
      case .favorites: return .favorites
      case .rewards: return .rewards
      case .recipes: return .recipes
      }
    }
  }
}

public enum TabNavigationAction: Equatable {
  case setNavigation(tag: TabNavigationState.Route.Tag)
}

public let tabNavigationReducer = Reducer<TabNavigationState, TabNavigationAction, Void> { state, action, _ in
  switch action {
  case .setNavigation(tag: .menu):
    state.route = .menu
    return .none
  case .setNavigation(tag: .favorites):
    state.route = .favorites
    return .none
  case .setNavigation(tag: .rewards):
    state.route = .rewards
    return .none
  case .setNavigation(tag: .recipes):
    state.route = .recipes
    return .none
  }
}
