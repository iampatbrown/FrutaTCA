import Foundation

public struct NutritionFact {
  public var identifier: String
  public var localizedFoodItemName: String

  public var referenceMass: Measurement<UnitMass>

  public var density: Density

  public var totalSaturatedFat: Measurement<UnitMass>
  public var totalMonounsaturatedFat: Measurement<UnitMass>
  public var totalPolyunsaturatedFat: Measurement<UnitMass>
  public var totalFat: Measurement<UnitMass> {
    return totalSaturatedFat + totalMonounsaturatedFat + totalPolyunsaturatedFat
  }

  public var cholesterol: Measurement<UnitMass>
  public var sodium: Measurement<UnitMass>

  public var totalCarbohydrates: Measurement<UnitMass>
  public var dietaryFiber: Measurement<UnitMass>
  public var sugar: Measurement<UnitMass>

  public var protein: Measurement<UnitMass>

  public var calcium: Measurement<UnitMass>
  public var potassium: Measurement<UnitMass>

  public var vitaminA: Measurement<UnitMass>
  public var vitaminC: Measurement<UnitMass>
  public var iron: Measurement<UnitMass>

  public struct Density {
    public var mass: Measurement<UnitMass>
    public var volume: Measurement<UnitVolume>

    public init(mass: Measurement<UnitMass>, volume: Measurement<UnitVolume>) {
      self.mass = mass
      self.volume = volume
    }
  }
}
