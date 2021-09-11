import ComposableArchitecture
import SharedModels
import SmoothieCore
import SwiftUI

struct RecipeNavigationLink: View {
  let store: Store<RecipeState, RecipeAction>
  @Binding var selection: Smoothie.ID?

  var body: some View {
    WithViewStore(self.store) { viewStore in
      NavigationLink(tag: viewStore.id, selection: $selection) {
        RecipeView(store: self.store)
      } label: {
        SmoothieRow(state: viewStore.toSmoothieState)
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

// TODO: Get rid of this...
extension RecipeState {
  public var toSmoothieState: SmoothieState {
    SmoothieState(
      id: id,
      title: title,
      description: description,
      measuredIngredients: measuredIngredients,
      hasFreeRecipe: hasFreeRecipe,
      isFavorite: isFavorite,
      energy: energy
    )
  }
}

extension SmoothieState {
  public var toRecipeState: RecipeState {
    RecipeState(
      id: id,
      title: title,
      description: description,
      measuredIngredients: measuredIngredients,
      hasFreeRecipe: hasFreeRecipe,
      isFavorite: isFavorite,
      smoothieCount: 1,
      energy: energy
    )
  }
}
