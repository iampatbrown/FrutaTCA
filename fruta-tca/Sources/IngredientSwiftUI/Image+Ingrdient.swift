import IngredientCore
import SwiftUI

extension Image {
  public init(_ ingredient: Ingredient) {
    // TODO: inject bundle
    self = Image(ingredient.id, bundle: bundle, label: Text(ingredient.name))
      .renderingMode(.original)
  }
}
