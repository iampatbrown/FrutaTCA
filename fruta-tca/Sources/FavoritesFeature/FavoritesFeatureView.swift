import ComposableArchitecture
import SmoothieCore
import SwiftUI

public typealias FavoritesFeatureState = SmoothiesState
public typealias FavoritesFeatureAction = SmoothiesAction
public typealias FavoritesFeatureEnvironment = SmoothiesEnvironment
public let favoritesFeatureReducer = smoothiesReducer

public struct FavoritesFeatureView: View {
  let store: Store<FavoritesFeatureState, FavoritesFeatureAction>

  public init(store: Store<FavoritesFeatureState, FavoritesFeatureAction>) {
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

extension FavoritesFeatureState {
  var filteringFavorites: Self {
    .init(smoothies: favoriteSmoothies, selection: selection, searchQuery: searchQuery)
  }
}
