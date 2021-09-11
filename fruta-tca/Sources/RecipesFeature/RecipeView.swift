import ComposableArchitecture
import SharedModels
import SmoothieCore
import SwiftUI

public struct RecipeState: Equatable, Identifiable {
  public var id: Smoothie.ID
  public var title: String
  public var description: AttributedString
  public var measuredIngredients: [MeasuredIngredient]
  public var hasFreeRecipe: Bool
  public var smoothieCount: Int
  @BindableState public var isFavorite: Bool

  public var menuIngredients: [MeasuredIngredient] {
    measuredIngredients.filter { $0.id != "water" } // TODO: Use water id
  }

  public var energy: Measurement<UnitEnergy>

  public init(
    id: Smoothie.ID,
    title: String,
    description: AttributedString,
    measuredIngredients: [MeasuredIngredient],
    hasFreeRecipe: Bool,
    isFavorite: Bool,
    smoothieCount: Int,
    energy: Measurement<UnitEnergy>
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.measuredIngredients = measuredIngredients
    self.hasFreeRecipe = hasFreeRecipe
    self.isFavorite = isFavorite
    self.smoothieCount = smoothieCount
    self.energy = energy
  }
}

public enum RecipeAction: Equatable, BindableAction {
  case toggleFavorite
  case binding(BindingAction<RecipeState>)
}

public let recipeReducer = Reducer<RecipeState, RecipeAction, Void> { state, action, _ in
  switch action {
  case .toggleFavorite:
    state.isFavorite.toggle()
    return .none
  case .binding:
    return .none
  }
}.binding()

public struct RecipeView: View {
  let store: Store<RecipeState, RecipeAction>

  public init(store: Store<RecipeState, RecipeAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        VStack(alignment: .leading) {
          Image("")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxHeight: 300)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .redacted(reason: .placeholder)
            .overlay {
              RoundedRectangle(cornerRadius: 24, style: .continuous)
                .strokeBorder(.quaternary, lineWidth: 0.5)
            }

          VStack(alignment: .leading) {
            Text("Ingredients")
              .font(Font.title).bold()
              .foregroundStyle(.secondary)

            VStack {
              ForEach(0 ..< viewStore.measuredIngredients.count) { index in
                Text(viewStore.measuredIngredients[index].ingredient.name)
                  .padding(.horizontal)
                if index < viewStore.measuredIngredients.count - 1 {
                  Divider()
                }
              }
            }
          }
        }
      }
      .navigationTitle(viewStore.title)
      .toolbar {
        SmoothieFavoriteButton(isFavorite: viewStore.$isFavorite)
      }
    }
  }
}
