import ComposableArchitecture
import SharedModels
import SwiftUI

struct SmoothieNavigationLink: View {
  let store: Store<SmoothieState, SmoothieAction>
  @Binding var selection: Smoothie.ID?

  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationLink(tag: viewStore.id, selection: $selection) {
        SmoothieView(store: self.store)
      } label: {
        SmoothieRow(state: viewStore.state)
      }.swipeActions {
        Button { viewStore.send(.toggleFavorite, animation: .default) }
        label: {
          Label {
            Text("Favorite")
          } icon: {
            Image(systemName: "heart")
          }
        }
      }
    }
  }
}
