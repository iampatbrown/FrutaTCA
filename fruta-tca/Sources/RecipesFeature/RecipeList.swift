import ComposableArchitecture
import SmoothiesSwiftUI
import SwiftUI

public struct RecipeList: View {
  let store: Store<RecipesState, RecipesAction>
  @ObservedObject var viewStore: ViewStore<RecipesState, RecipesAction>

  public init(store: Store<RecipesState, RecipesAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  public var body: some View {
    List {
      #if os(iOS)
        if !viewStore.allRecipesUnlocked {
          Section {
            unlockButton
              .listRowInsets(EdgeInsets())
              .listRowBackground(EmptyView())
              .listSectionSeparator(.hidden)
              .listRowSeparator(.hidden)
          }
          .listSectionSeparator(.hidden)
        }
      #endif

      ForEachStore(
        store
          .scope(
            state: \.listedRecipes,
            action: RecipesAction.recipe(id:action:)
          )
      ) { childStore in
        WithViewStore(childStore) { childViewStore in
          NavigationLink(
            tag: childViewStore.id,
            selection: viewStore.binding(
              get: \.selection,
              send: RecipesAction.setRecipe(selection:)
            )
          ) {
            RecipeView(store: childStore)
          } label: {
            SmoothieRow(smoothie: childViewStore.smoothie)
              .padding(.vertical, 5)
          }
        }
      }
    }
    #if os(iOS)
      .listStyle(.insetGrouped)
    #elseif os(macOS)
      .safeAreaInset(edge: .bottom, spacing: 0) {
        if !viewStore.allRecipesUnlocked {
          unlockButton
            .padding(8)
        }
      }
    #endif

    .navigationTitle(Text(
      "Recipes",
      comment: "Title of the 'recipes' app section showing the list of smoothie recipes."
    ))
      .animation(.spring(response: 1, dampingFraction: 1), value: viewStore.allRecipesUnlocked)
      .searchable(text: viewStore.binding(get: \.searchQuery, send: RecipesAction.searchQueryChanged)) {
        ForEach(viewStore.searchSuggestions) { suggestion in
          Text(suggestion.name).searchCompletion(suggestion.name)
        }
      }
      .onAppear { viewStore.send(.onAppear) }
  }

  @ViewBuilder
  var unlockButton: some View {
    Group {
      if let product = viewStore.unlockAllRecipesProduct {
        RecipeUnlockButton(
          product: RecipeUnlockButton.Product(for: product),
          purchaseAction: { viewStore.send(.store(.purchase(product))) }
        )
      } else {
        RecipeUnlockButton(
          product: RecipeUnlockButton.Product(
            title: "Unlock All Recipes",
            description: "Loading…",
            availability: .unavailable
          ),
          purchaseAction: {}
        )
      }
    }
    .transition(.scale.combined(with: .opacity))
  }
}
