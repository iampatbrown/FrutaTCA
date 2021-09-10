import SwiftUI
import SharedModels
import ComposableArchitecture

public struct SmoothieState: Equatable, Identifiable {
  public var id: Smoothie.ID
  public var title: String
  public var description: AttributedString
  public var measuredIngredients: [MeasuredIngredient]
  public var hasFreeRecipe: Bool
  @BindableState public var isFavorite: Bool





  public var menuIngredients: [MeasuredIngredient] {
    measuredIngredients.filter { $0.id != "water" } // TODO: Use water id
  }

  public var energy: Measurement<UnitEnergy> 
}


public enum SmoothieAction: Equatable, BindableAction {
  case toggleFavorite
  case binding(BindingAction<SmoothieState>)
}



struct SmoothieView: View {
  let store: Store<SmoothieState, SmoothieAction>

    var body: some View {
      // Container
      Text("Smoothie View")
      // Nav - Toggle Favorites
      // Sheet - OrderPlacedView

      // BottomBar - Account
    }
}

