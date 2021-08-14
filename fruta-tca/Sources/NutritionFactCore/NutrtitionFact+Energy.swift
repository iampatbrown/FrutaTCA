import Foundation

private let kilocaloriesInFat: Double = 9
private let kilocaloriesInCarb: Double = 4
private let kilocaloriesInProtein: Double = 4

extension NutritionFact {
  public var kilocaloriesFromFat: Double {
    totalFat.converted(to: .grams).value * kilocaloriesInFat
  }

  public var kilocaloriesFromCarbohydrates: Double {
    (totalCarbohydrates - dietaryFiber).converted(to: .grams).value * kilocaloriesInCarb
  }

  public var kilocaloriesFromProtein: Double {
    protein.converted(to: .grams).value * kilocaloriesInProtein
  }

  public var kilocalories: Double {
    kilocaloriesFromFat + kilocaloriesFromCarbohydrates + kilocaloriesFromProtein
  }

  public var energy: Measurement<UnitEnergy> {
    Measurement<UnitEnergy>(value: kilocalories, unit: .kilocalories)
  }
}
