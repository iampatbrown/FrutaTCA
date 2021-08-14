import ComposableArchitecture
import IngredientCore
import SmoothieCore
import SmoothiesCore
import SmoothieSwiftUI
import SwiftUI

public struct SmoothieList: View {
  let store: Store<SmoothiesState, SmoothiesAction>
  @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

  struct ViewState: Equatable {
    var listedSmoothies: IdentifiedArrayOf<SmoothieState>
    var selection: Smoothie.ID?
    var searchQuery: String
    var searchSuggestions: [Ingredient]

    init(state: SmoothiesState) {
      self.listedSmoothies = state.listedSmoothies
      self.selection = state.selection
      self.searchQuery = state.searchQuery
      self.searchSuggestions = state.searchSuggestions
    }
  }

  enum ViewAction: Equatable {
    case setSmoothie(selection: Smoothie.ID?)
    case searchQueryChanged(String)
  }

  public init(store: Store<SmoothiesState, SmoothiesAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init, action: SmoothiesAction.init))
  }

  public var body: some View {
    List {
      ForEachStore(
        store
          .scope(
            state: \.listedSmoothies,
            action: SmoothiesAction.smoothie(id:action:)
          )
      ) { childStore in
        WithViewStore(childStore) { childViewStore in
          NavigationLink(
            tag: childViewStore.id,
            selection: viewStore.binding(
              get: \.selection,
              send: ViewAction.setSmoothie(selection:)
            )
          ) {
            SmoothieView(store: childStore)
          } label: {
            SmoothieRow(smoothie: childViewStore.smoothie)
          }
          .swipeActions {
            Button {
              childViewStore.send(.favorite(.toggleIsFavorite), animation: .default)
            } label: {
              Label {
                Text("Favorite", comment: "Swipe action button in smoothie list")
              } icon: {
                Image(systemName: "heart")
              }
            }.tint(.accentColor)
          }.onAppear { childViewStore.send(.onAppear) }
        }
      }
    }.searchable(text: viewStore.binding(get: \.searchQuery, send: ViewAction.searchQueryChanged)) {
      ForEach(viewStore.searchSuggestions) { suggestion in
        Text(suggestion.name).searchCompletion(suggestion.name)
      }
    }
  }
}

extension SmoothiesAction {
  init(action: SmoothieList.ViewAction) {
    switch action {
    case let .searchQueryChanged(searchQuery):
      self = .searchQueryChanged(searchQuery)
    case let .setSmoothie(selection):
      self = .setSmoothie(selection: selection)
    }
  }
}
