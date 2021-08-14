import ComposableArchitecture
import FavoriteCore
import SwiftUI

public struct FavoriteButton<ID>: View where ID: Hashable {
  let store: Store<FavoriteState<ID>, FavoriteAction>

  public init(store: Store<FavoriteState<ID>, FavoriteAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      Button(action: { viewStore.send(.toggleIsFavorite) }) {
        if viewStore.isFavorite {
          Label {
            Text("Remove from Favorites", comment: "Toolbar button/menu item to remove a smoothie from favorites")
          } icon: {
            Image(systemName: "heart.fill")
          }
        } else {
          Label {
            Text("Add to Favorites", comment: "Toolbar button/menu item to add a smoothie to favorites")
          } icon: {
            Image(systemName: "heart")
          }
        }
      }
    }
  }
}
