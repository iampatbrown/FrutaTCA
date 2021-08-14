import Foundation

public struct NutritionFact: Equatable {
  public init(
    identifier: String,
    localizedFoodItemName: String,
    density: Density,
    referenceMass: Measurement<UnitMass>,
    saturatedFat: Measurement<UnitMass>,
    monounsaturatedFat: Measurement<UnitMass>,
    polyunsaturatedFat: Measurement<UnitMass>,
    cholesterol: Measurement<UnitMass>,
    sodium: Measurement<UnitMass>,
    totalCarbohydrates: Measurement<UnitMass>,
    dietaryFiber: Measurement<UnitMass>,
    sugar: Measurement<UnitMass>,
    protein: Measurement<UnitMass>,
    calcium: Measurement<UnitMass>,
    potassium: Measurement<UnitMass>,
    vitaminA: Measurement<UnitMass>,
    vitaminC: Measurement<UnitMass>,
    iron: Measurement<UnitMass>
  ) {
    self.identifier = identifier
    self.localizedFoodItemName = localizedFoodItemName

    self.density = density
    self.referenceMass = referenceMass
    self.saturatedFat = saturatedFat
    self.monounsaturatedFat = monounsaturatedFat
    self.polyunsaturatedFat = polyunsaturatedFat
    self.cholesterol = cholesterol
    self.sodium = sodium
    self.totalCarbohydrates = totalCarbohydrates
    self.dietaryFiber = dietaryFiber
    self.sugar = sugar
    self.protein = protein
    self.calcium = calcium
    self.potassium = potassium
    self.vitaminA = vitaminA
    self.vitaminC = vitaminC
    self.iron = iron
  }

  public var identifier: String
  public var localizedFoodItemName: String
  public var density: Density
  public var referenceMass: Measurement<UnitMass>
  public var saturatedFat: Measurement<UnitMass>
  public var monounsaturatedFat: Measurement<UnitMass>
  public var polyunsaturatedFat: Measurement<UnitMass>
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

  public var totalFat: Measurement<UnitMass> {
    saturatedFat + monounsaturatedFat + polyunsaturatedFat
  }
}

extension NutritionFact {
  public static var zero: NutritionFact {
    NutritionFact(
      identifier: "",
      localizedFoodItemName: "",
      density: Density(mass: .grams(1), volume: .cups(1)),
      referenceMass: .grams(1),
      saturatedFat: .grams(0),
      monounsaturatedFat: .grams(0),
      polyunsaturatedFat: .grams(0),
      cholesterol: .grams(0),
      sodium: .grams(0),
      totalCarbohydrates: .grams(0),
      dietaryFiber: .grams(0),
      sugar: .grams(0),
      protein: .grams(0),
      calcium: .grams(0),
      potassium: .grams(0),
      vitaminA: .grams(0),
      vitaminC: .grams(0),
      iron: .grams(0)
    )
  }
}
