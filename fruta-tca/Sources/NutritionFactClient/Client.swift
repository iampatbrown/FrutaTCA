import Foundation
import NutritionFactCore

public struct NutritionFactClient {
  var lookupFoodItemForMass: (String, Measurement<UnitMass>) -> NutritionFact?
  var lookupFoodItemForVolume: (String, Measurement<UnitVolume>) -> NutritionFact?

  public init(
    lookupFoodItemForMass: @escaping (String, Measurement<UnitMass>) -> NutritionFact?,
    lookupFoodItemForVolume: @escaping (String, Measurement<UnitVolume>) -> NutritionFact?
  ) {
    self.lookupFoodItemForMass = lookupFoodItemForMass
    self.lookupFoodItemForVolume = lookupFoodItemForVolume
  }

  public func lookupFoodItem(
    _ foodItemIdentifier: String,
    forMass mass: Measurement<UnitMass>
  ) -> NutritionFact? {
    lookupFoodItemForMass(foodItemIdentifier, mass)
  }

  public func lookupFoodItem(
    _ foodItemIdentifier: String,
    forVolume volume: Measurement<UnitVolume> = Measurement(value: 1, unit: .cups)
  ) -> NutritionFact? {
    lookupFoodItemForVolume(foodItemIdentifier, volume)
  }
}
