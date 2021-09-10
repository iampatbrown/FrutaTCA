import ComposableArchitecture
import SharedModels
import SwiftUI

public struct SmoothieListState: Equatable {
  public var account: String = ""
  @BindableState public var searchString: String = ""
  @BindableState public var selection: Smoothie.ID?
  public var smoothies: IdentifiedArrayOf<SmoothieState>
}

public enum SmoothieListAction: Equatable, BindableAction {
  case binding(BindingAction<SmoothieListState>)
  case smoothie(id: Smoothie.ID, action: SmoothieAction)
}

public struct SmoothieList: View {
  let store: Store<SmoothieListState, SmoothieListAction>

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
        ForEachStore(
          self.store.scope(state: \.smoothies, action: SmoothieListAction.smoothie(id:action:))
        ) { childStore in
          SmoothieNavigationLink(store: childStore, selection: viewStore.$selection)
        }
      }.searchable(text: viewStore.$searchString) {
        Text(viewStore.searchString)
//        ForEach(viewStore.searchSuggestions) { ... }
      }
    }
  }
}
