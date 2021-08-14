import NutritionFactCore
import SwiftUI

// Not a fan of this

public struct Nutrition: Identifiable {
  public var id: String
  public var name: LocalizedStringKey
  public var measurement: Measurement<UnitMass>
  public var indented: Bool = false
}

extension NutritionFact {
  public var nutritions: [Nutrition] {
    [
      Nutrition(
        id: "totalFat",
        name: "Total Fat",
        measurement: totalFat
      ),
      Nutrition(
        id: "saturatedFat",
        name: "Saturated Fat",
        measurement: saturatedFat,
        indented: true
      ),
      Nutrition(
        id: "monounsaturatedFat",
        name: "Monounsaturated Fat",
        measurement: monounsaturatedFat,
        indented: true
      ),
      Nutrition(
        id: "polyunsaturatedFat",
        name: "Polyunsaturated Fat",
        measurement: polyunsaturatedFat,
        indented: true
      ),
      Nutrition(
        id: "cholesterol",
        name: "Cholesterol",
        measurement: cholesterol
      ),
      Nutrition(
        id: "sodium",
        name: "Sodium",
        measurement: sodium
      ),
      Nutrition(
        id: "totalCarbohydrates",
        name: "Total Carbohydrates",
        measurement: totalCarbohydrates
      ),
      Nutrition(
        id: "dietaryFiber",
        name: "Dietary Fiber",
        measurement: dietaryFiber,
        indented: true
      ),
      Nutrition(
        id: "sugar",
        name: "Sugar",
        measurement: sugar,
        indented: true
      ),
      Nutrition(
        id: "protein",
        name: "Protein",
        measurement: protein
      ),
      Nutrition(
        id: "calcium",
        name: "Calcium",
        measurement: calcium
      ),
      Nutrition(
        id: "potassium",
        name: "Potassium",
        measurement: potassium
      ),
      Nutrition(
        id: "vitaminA",
        name: "Vitamin A",
        measurement: vitaminA
      ),
      Nutrition(
        id: "vitaminC",
        name: "Vitamin C",
        measurement: vitaminC
      ),
      Nutrition(
        id: "iron",
        name: "Iron",
        measurement: iron
      ),
    ]
  }
}
