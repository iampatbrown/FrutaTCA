import ComposableArchitecture
import SwiftUI

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

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init, action: ViewAction.to(appAction:))) { viewStore in

      TabView(selection: viewStore.$selection) {
        NavigationView {
          Text("SmoothieMenu")
        }
        .tabItem {
          let menuText = Text("Menu", comment: "Smoothie menu tab title")
          Label {
            menuText
          } icon: {
            Image(systemName: "list.bullet")
          }.accessibility(label: menuText)
        }
        .tag(AppTab.menu)

        NavigationView {
          Text("FavoriteSmoothies")
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
        .tag(AppTab.favorites)

        NavigationView {
          Text("RewardsView")
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
        .tag(AppTab.rewards)

        NavigationView {
          Text("RecipeList")
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
        .tag(AppTab.recipes)
      }
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

// struct AppTabNavigationView_Previews: PreviewProvider {
//  static var previews: some View {
//    AppTabNavigationView()
//  }
// }
