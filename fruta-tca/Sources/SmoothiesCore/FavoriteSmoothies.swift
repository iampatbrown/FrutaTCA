import ComposableArchitecture
import SwiftUI

public struct FavoriteSmoothies: View {
  let store: Store<SmoothieListState, SmoothieListAction>

  public init(store: Store<SmoothieListState, SmoothieListAction>) {
    self.store = store
  }

  public var body: some View {
    SmoothieList(store: self.store)
      .overlay {
        WithViewStore(self.store.scope(state: { $0.listedSmoothies.isEmpty })) { isEmpty in
          if isEmpty.state {
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
      }
      .navigationTitle(Text(
        "Favorites",
        comment: "Title of the 'favorites' app section showing the list of favorite smoothies"
      ))
  }
}
