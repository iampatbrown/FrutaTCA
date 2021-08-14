import ComposableArchitecture
import SmoothiesCore
import SwiftUI

public struct FavoriteSmoothies: View {
  let store: Store<SmoothiesState, SmoothiesAction>

  public init(store: Store<SmoothiesState, SmoothiesAction>) {
    self.store = store.scope(state: \.filteringFavorites)
  }

  public var body: some View {
    SmoothieList(store: store)
      .overlay {
        WithViewStore(store.scope(state: { $0.favoriteSmoothies.isEmpty }).actionless) { viewStore in
          if viewStore.state {
            Text(
              "Add some smoothies to your favorites!",
              comment: "Placeholder text shown in list of smoothies when no favorite smoothies have been added yet"
            )
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background()
            .ignoresSafeArea()
          }
        }
        .navigationTitle(Text(
          "Favorites",
          comment: "Title of the 'favorites' app section showing the list of favorite smoothies"
        ))
      }
  }
}

extension SmoothiesState {
  var filteringFavorites: Self {
    .init(smoothies: favoriteSmoothies, selection: selection, searchQuery: searchQuery)
  }
}
