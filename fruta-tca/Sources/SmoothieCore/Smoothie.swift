import Foundation
import IngredientCore
import NutritionFactCore

public struct Smoothie: Equatable, Identifiable {
  public var id: String
  public var title: String
  public var description: AttributedString
  public var measuredIngredients: [MeasuredIngredient]

  public init(
    id: String,
    title: String,
    description: AttributedString,
    measuredIngredients: [MeasuredIngredient]
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.measuredIngredients = measuredIngredients
  }
}

extension Smoothie {
  public var menuIngredients: [MeasuredIngredient] {
    measuredIngredients.filter { $0.id != Ingredient.water.id }
  }

  public var kilocalories: Int {
    let value = measuredIngredients.reduce(0) { total, ingredient in total + ingredient.kilocalories }
    return Int(round(Double(value) / 10.0) * 10)
  }

  public var energy: Measurement<UnitEnergy> {
    return Measurement<UnitEnergy>(value: Double(kilocalories), unit: .kilocalories)
  }

  public var nutritionFact: NutritionFact? {
    let facts = measuredIngredients.compactMap(\.nutritionFact)
    guard let firstFact = facts.first else { return nil }
    return facts.dropFirst().reduce(firstFact, +)
  }

  public func matches(_ string: String) -> Bool {
    string.isEmpty ||
      title.localizedCaseInsensitiveContains(string) ||
      menuIngredients.contains {
        $0.ingredient.name.localizedCaseInsensitiveContains(string)
      }
  }
}
