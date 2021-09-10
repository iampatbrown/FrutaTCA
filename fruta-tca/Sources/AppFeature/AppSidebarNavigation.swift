import ComposableArchitecture
import SmoothieCore
import SwiftUI

public enum SidebarItem: Equatable {
  case menu
  case favorites
  case recipes
}

struct AppSidebarNavigationView: View {
  let store: Store<AppState, AppAction>
  struct ViewState: Equatable {
    @BindableState var selection: SidebarItem?
    @BindableState var isPresentingRewards: Bool

    init(state: AppState) {
      self.selection = state.navigation.currentSelection
      self.isPresentingRewards = state.navigation.isPresentingRewards
    }
  }

  enum ViewAction: Equatable, BindableAction {
    case binding(BindingAction<ViewState>)
  }

  init(store: Store<AppState, AppAction>) {
    self.store = store
  }

  var body: some View {
    WithViewStore(store.scope(state: ViewState.init, action: ViewAction.to(appAction:))) { viewStore in
      NavigationView {
        List {
          NavigationLink(tag: SidebarItem.menu, selection: viewStore.$selection) {
            Text("SmoothieMenu")
          } label: {
            Label("Menu", systemImage: "list.bullet")
          }

          NavigationLink(tag: SidebarItem.favorites, selection: viewStore.$selection) {
            Text("Favorites")
          } label: {
            Label("Favorites", systemImage: "heart")
          }

          NavigationLink(tag: SidebarItem.recipes, selection: viewStore.$selection) {
            Text("Recipes")
          } label: {
            Label("Recipes", systemImage: "book.closed")
          }
        }
        .navigationTitle("Fruta")
        .safeAreaInset(edge: .bottom, spacing: 0) {
          RewardsPocket(store: self.store, isPresentingRewards: viewStore.$isPresentingRewards)
        }

        Text("Select a category")
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()

        Text("Select a smoothie")
          .foregroundStyle(.secondary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .ignoresSafeArea()
          .toolbar {
            SmoothieFavoriteButton(isFavorite: .constant(false))
              .disabled(true)
          }
      }
    }
  }

  struct RewardsPocket: View { // TODO: I have no idea what a 'Pocket' is...
    let store: Store<AppState, AppAction>
    @Binding var isPresentingRewards: Bool

    var body: some View {
      Button(action: { isPresentingRewards = true }) {
        Label("Rewards", systemImage: "seal")
      }
      .sheet(isPresented: $isPresentingRewards) {
        Text("Rewards")
        #if os(iOS)
          .overlay(alignment: .topTrailing) {
            Button(action: { isPresentingRewards = false }) { Text("Done") }
          }
        #else
          .frame(minWidth: 400, maxWidth: 600, minHeight: 400, maxHeight: 600)
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button(action: { isPresentingRewards = false }) { Text("Done") }
            }
          }
        #endif
      }
    }
  }
}

extension AppState {
  var sidebarView: AppSidebarNavigationView.ViewState {
    get { .init(state: self) }
    set {
      guard navigation.style == .sidebar else { return }
      self.navigation = .sidebar(
        selection: newValue.selection,
        isPresentingRewards: newValue.isPresentingRewards
      )
    }
  }
}

extension AppSidebarNavigationView.ViewAction {
  static func to(appAction action: Self) -> AppAction {
    switch action {
    case let .binding(bindingAction):
      return .binding(bindingAction.pullback(\AppState.sidebarView))
    }
  }
}
