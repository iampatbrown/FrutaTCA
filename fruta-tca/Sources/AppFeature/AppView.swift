import AccountSwiftUI
import AppCore
import ComposableArchitecture
import RecipesSwiftUI
import RecipeSwiftUI
import SharedSwiftUI
import SmoothiesSwiftUI
import SwiftUI

public struct AppView: View {
  let store: Store<AppState, AppAction>
  @ObservedObject var viewStore: ViewStore<ViewState, AppAction>

  struct ViewState: Equatable {
    init(state: AppState) {
      self.navigation = state.navigation
    }

    var navigation: TabNavigationState
  }

  public init(store: Store<AppState, AppAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init))
  }

  public var body: some View {
    TabView(
      selection: viewStore.binding(
        get: \.navigation.route.tag,
        send: { AppAction.navigation(.setNavigation(tag: $0)) }
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
      .tag(TabNavigationState.Route.Tag.menu)

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
      .tag(TabNavigationState.Route.Tag.favorites)

      NavigationView {
        RewardsView(store: self.store.scope(state: \.account, action: AppAction.rewards))
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
      .tag(TabNavigationState.Route.Tag.rewards)

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
      .tag(TabNavigationState.Route.Tag.recipes)
    }
//    .navigationViewStyle(.stack)
//     https://stackoverflow.com/questions/65316497
//     suppresses LayoutConstraint error but also messes up tabView. will look into this at some point
  }
}
