import SwiftUI

public enum AppNavigation: Equatable {
  case sidebar(selection: SidebarItem?, isPresentingRewards: Bool)
  case tab(current: AppTab, previous: AppTab?)

  var style: Style {
    switch self {
    case .sidebar: return .sidebar
    case .tab: return .tab
    }
  }

  var currentSelection: SidebarItem? {
    switch self {
    case let .sidebar(selection, _):
      return selection
    case let .tab(current, _):
      return current.toSidebarItem
    }
  }

  var currentTab: AppTab {
    switch self {
    case .sidebar(_, true):
      return .rewards
    case let .sidebar(selection, _):
      return selection?.toTab ?? .menu
    case let .tab(current, _):
      return current
    }
  }

  var isPresentingRewards: Bool {
    switch self {
    case .sidebar(_, true), .tab(.rewards, _):
      return true
    default:
      return false
    }
  }

  var toSidebarNavigation: AppNavigation {
    switch self {
    case .sidebar:
      return self
    case let .tab(.rewards, previous):
      return .sidebar(selection: previous?.toSidebarItem, isPresentingRewards: true)
    case let .tab(current, _):
      return .sidebar(selection: current.toSidebarItem, isPresentingRewards: false)
    }
  }

  var toTabNavigation: AppNavigation {
    switch self {
    case let .sidebar(selection, true):
      return .tab(current: .rewards, previous: selection?.toTab)
    case let .sidebar(selection, false):
      return .tab(current: selection?.toTab ?? .menu, previous: nil)
    case .tab:
      return self
    }
  }

  mutating func toggle() {
    self = style == .sidebar ? self.toTabNavigation : self.toSidebarNavigation
  }

  public enum Style: Equatable {
    case sidebar
    case tab
  }
}

extension SidebarItem {
  var toTab: AppTab {
    switch self {
    case .menu: return .menu
    case .favorites: return .favorites
    case .recipes: return .recipes
    }
  }
}

extension AppTab {
  var toSidebarItem: SidebarItem? {
    switch self {
    case .menu: return .menu
    case .favorites: return .favorites
    case .recipes: return .recipes
    case .rewards: return nil
    }
  }
}
