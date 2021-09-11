import ComposableArchitecture
import SwiftUI

public typealias FavoritesState = SmoothieListState

public typealias FavoritesAction = SmoothieListAction

public let favoritesReducer: Reducer<FavoritesState, FavoritesAction, Void> = smoothieListReducer

public struct FavoriteSmoothies: View {
  let store: Store<FavoritesState, FavoritesAction>

  public init(store: Store<FavoritesState, FavoritesAction>) {
    self.store = store.scope(state: { $0.filteringFavorites() }) // TODO: is it okay to do this here?
  }

  public var body: some View {
    SmoothieList(store: self.store)
      .overlay {
        WithViewStore(self.store.scope(state: { $0.smoothies.isEmpty })) { viewStore in
          if viewStore.state {
            Text("Add some smoothies to your favorites!")
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
              .ignoresSafeArea()
          }
        }
      }
      .navigationTitle(Text("Favorites"))
  }
}

extension SmoothieListState {
  func filteringFavorites() -> Self {
    var copy = self
    copy.smoothies = self.smoothies.filter(\.isFavorite)
    return copy
  }
}
