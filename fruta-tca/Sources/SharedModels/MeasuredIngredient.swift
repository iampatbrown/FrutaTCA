import Foundation

public struct MeasuredIngredient: Equatable, Identifiable {
  public var ingredient: Ingredient
  public var measurement: Measurement<UnitVolume>

  public init(_ ingredient: Ingredient, measurement: Measurement<UnitVolume>) {
    self.ingredient = ingredient
    self.measurement = measurement
  }

  public var id: Ingredient.ID { ingredient.id }
}
