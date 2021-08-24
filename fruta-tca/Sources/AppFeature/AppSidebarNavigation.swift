import ComposableArchitecture
import OrdersFeature
import RecipesFeature
import SmoothiesCore
import SwiftUI

public struct AppSidebarNavigation: View {
  let store: Store<AppState, AppAction>

  typealias SidebarItem = AppState.Route.SidebarItem

  struct ViewState: Equatable {
    var route: SidebarItem?
  }

  enum ViewAction: Equatable {
    case setNavigation(SidebarItem?)
  }

  public init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store.scope(state: ViewState.init, action: ViewAction.to(appAction:))) { viewStore in
      NavigationView {
        List {
          NavigationLink(
            tag: SidebarItem.menu,
            selection: viewStore.binding(
              get: \.route,
              send: ViewAction.setNavigation
            )
          ) {
            SmoothieMenu(store: self.store.scope(state: \.menu, action: AppAction.menu))
          } label: {
            Label("Menu", systemImage: "list.bullet")
          }

          NavigationLink(
            tag: SidebarItem.favorites,
            selection: viewStore.binding(
              get: \.route,
              send: ViewAction.setNavigation
            )
          ) {
            FavoriteSmoothies(store: self.store.scope(state: \.favorites, action: AppAction.favorites))
          } label: {
            Label("Favorites", systemImage: "heart")
          }

          NavigationLink(
            tag: SidebarItem.recipes,
            selection: viewStore.binding(
              get: \.route,
              send: ViewAction.setNavigation
            )
          ) {
            RecipeList(store: self.store.scope(state: \.recipes, action: AppAction.recipes))
          } label: {
            Label("Recipes", systemImage: "book.closed")
          }
        }
        .navigationTitle("Fruta")
        .safeAreaInset(edge: .bottom, spacing: 0) {
          Pocket(store: self.store)
        }

        Text("Select a category")
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background()
          .ignoresSafeArea()

        Text("Select a smoothie")
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background()
          .ignoresSafeArea()
          .toolbar {
            SmoothieFavoriteButton(isFavorite: .constant(false))
              .disabled(true)
          }
      }
    }
  }

  struct Pocket: View {
    let store: Store<AppState, AppAction>
    @State private var presentingRewards: Bool = false
    // TODO: Probably replace this with .sidebar(SidebarNavigationState) instate of just .sidebar(SidebarItem?)

    var body: some View {
      Button(action: { presentingRewards = true }) {
        Label("Rewards", systemImage: "seal")
      }
      .controlSize(.large)
      .buttonStyle(.capsule)
      .padding(.vertical, 8)
      .padding(.horizontal, 16)
      .sheet(isPresented: $presentingRewards) {
        RewardsView(store: self.store.scope(state: \.rewards, action: AppAction.rewards))
        #if os(iOS)
          .overlay(alignment: .topTrailing) {
            Button(action: { presentingRewards = false }) {
              Text("Done", comment: "Button title to dismiss rewards sheet")
            }
            .font(.body.bold())
            .keyboardShortcut(.defaultAction)
            .buttonStyle(.capsule)
            .padding()
          }
        #else
          .frame(minWidth: 400, maxWidth: 600, minHeight: 400, maxHeight: 600)
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button(action: { presentingRewards = false }) {
                Text("Done", comment: "Button title to dismiss rewards sheet")
              }
            }
          }
        #endif
      }
    }
  }
}

extension AppState.Route {
  var sidebarItem: SidebarItem? {
    switch self {
     case let .sidebar(sidebarItem):
      return sidebarItem
    case .tab(.menu):
      return .menu
    case .tab(.favorites):
      return .favorites
    case .tab(.rewards):
      return nil
    case .tab(.recipes):
      return .recipes

    }
  }
}

extension AppSidebarNavigation.ViewState {
  init(state: AppState) {
    self.route = state.route.sidebarItem
  }
}

extension AppSidebarNavigation.ViewAction {
  static func to(appAction action: Self) -> AppAction {
    switch action {
    case let .setNavigation(sidebarItem):
      return .setNavigation(.sidebar(sidebarItem))
    }
  }
}
