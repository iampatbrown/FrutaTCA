import ComposableArchitecture
import RewardsFeature
import SmoothieCore
import SwiftUI
import RecipesFeature

public enum AppTab: Equatable {
  case menu
  case favorites
  case rewards
  case recipes
}

struct AppTabNavigationView: View {
  let store: Store<AppState, AppAction>

  struct ViewState: Equatable {
    @BindableState var selection: AppTab

    init(state: AppState) {
      self.selection = state.navigation.currentTab
    }
  }

  enum ViewAction: Equatable, BindableAction {
    case binding(BindingAction<ViewState>)
  }

  var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init, action: ViewAction.to(appAction:))) { viewStore in

      TabView(selection: viewStore.$selection) {
        NavigationView {
          SmoothieMenu(store: self.store.scope(state: \.menu, action: AppAction.menu))
        }
        .tabItem {
          Label("Menu", systemImage: "list.bullet")
        }
        .tag(AppTab.menu)

        NavigationView {
          FavoriteSmoothies(store: self.store.scope(state: \.favorites, action: AppAction.favorites))
        }
        .tabItem {
          Label("Favorites", systemImage: "heart.fill")
        }
        .tag(AppTab.favorites)

        NavigationView {
          RewardsView(store: self.store.scope(state: \.rewards, action: AppAction.rewards))
        }
        .tabItem {
          Label("Rewards", systemImage: "seal.fill")
        }
        .tag(AppTab.rewards)

        NavigationView {
          RecipeList(store: self.store.scope(state: \.recipes, action: AppAction.recipes))
        }
        .tabItem {
          Label("Recipes", systemImage: "book.closed.fill")
        }
        .tag(AppTab.recipes)
      }.navigationViewStyle(.stack)
    }
  }
}

extension AppState {
  var tabView: AppTabNavigationView.ViewState {
    get { .init(state: self) }
    set {
      guard navigation.style == .tab, navigation.currentTab != newValue.selection else { return }
      self.navigation = .tab(current: newValue.selection, previous: navigation.currentTab)
    }
  }
}

extension AppTabNavigationView.ViewAction {
  static func to(appAction action: Self) -> AppAction {
    switch action {
    case let .binding(bindingAction):
      return .binding(bindingAction.pullback(\AppState.tabView))
    }
  }
}
