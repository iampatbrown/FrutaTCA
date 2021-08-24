//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by Pat Brown on 24/8/21.
//

import ComposableArchitecture
import OrdersFeature
import RecipesFeature
import SmoothiesCore
import SwiftUI

public struct AppTabNavigation: View {
  let store: Store<AppState, AppAction>

  typealias Tab = AppState.Route.Tab

  struct ViewState: Equatable {
    var route: Tab
  }

  enum ViewAction: Equatable {
    case setNavigation(Tab)
  }

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init, action: ViewAction.to(appAction:))) { viewStore in
      TabView(
        selection: viewStore.binding(
          get: \.route,
          send: ViewAction.setNavigation
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
        .tag(Tab.menu)

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
        .tag(Tab.favorites)

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
        .tag(Tab.rewards)

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
        .tag(Tab.recipes)
      }
    }
  }
}

// Which extension are preferred?
extension AppState.Route {
  var tab: Tab {
    switch self {
    case let .tab(tab):
      return tab
    case .sidebar(.menu):
      return .menu
    case .sidebar(.favorites):
      return .favorites
    case .sidebar(.recipes):
      return .recipes
    case .sidebar(.none):
      return .menu
    }
  }
}

extension AppTabNavigation.ViewState {
  init(state: AppState) {
    self.route = state.route.tab
  }

//  init(state: AppState) {
//    switch state.route {
//    case let .tab(tab):
//      self.tab = tab
//    case .sidebar(.menu):
//      self.tab = .menu
//    case .sidebar(.favorites):
//      self.tab = .favorites
//    case .sidebar(.recipes):
//      self.tab = .recipes
//    case .sidebar(.none):
//      self.tab = .menu
//    }
//  }
}

extension AppTabNavigation.ViewAction {
  static func to(appAction action: Self) -> AppAction {
    switch action {
    case let .setNavigation(tab):
      return .setNavigation(.tab(tab))
    }
  }
}

extension AppAction {
  init(_ action: AppTabNavigation.ViewAction) {
    switch action {
    case let .setNavigation(tab):
      self = .setNavigation(.tab(tab))
    }
  }
}
