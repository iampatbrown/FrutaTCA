import SwiftUI

public struct MeasuredIngredient: Identifiable, Codable {
  public var ingredient: Ingredient
  public var measurement: Measurement<UnitVolume>

  public init(_ ingredient: Ingredient, measurement: Measurement<UnitVolume>) {
    self.ingredient = ingredient
    self.measurement = measurement
  }

  // Identifiable
  public var id: Ingredient.ID { ingredient.id }
}

extension MeasuredIngredient {
  public var kilocalories: Int {
    guard let nutritionFact = nutritionFact else {
      return 0
    }
    return Int(nutritionFact.kilocalories)
  }

  // Nutritional information according to the quantity of this measurement.
  public var nutritionFact: NutritionFact? {
    guard let nutritionFact = ingredient.nutritionFact else {
      return nil
    }
    let mass = measurement.convertedToMass(usingDensity: nutritionFact.density)
    return nutritionFact.converted(toMass: mass)
  }
}

extension Ingredient {
  public func measured(with unit: UnitVolume) -> MeasuredIngredient {
    MeasuredIngredient(self, measurement: Measurement(value: 1, unit: unit))
  }
}

extension MeasuredIngredient {
  public func scaled(by scale: Double) -> MeasuredIngredient {
    return MeasuredIngredient(ingredient, measurement: measurement * scale)
  }
}
