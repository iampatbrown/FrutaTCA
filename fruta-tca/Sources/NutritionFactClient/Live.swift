import Foundation
import NutritionFactCore

extension NutritionFactClient {
  public static var live: Self { // TODO: use path
    let nutritionFacts: [String: NutritionFact] = {
      if let jsonURL = Bundle.module.url(
        forResource: "NutritionFacts/NutritionalItems",
        withExtension: "json"
      ),
        let jsonData = try? Data(contentsOf: jsonURL),
        let facts = try? JSONDecoder().decode([String: NutritionFact].self, from: jsonData)
      {
        return facts
      } else {
        return [String: NutritionFact]()
      }
    }()

    return Self(
      lookupFoodItemForMass: { foodItemIdentifier, mass in
        nutritionFacts[foodItemIdentifier]?.converted(toMass: mass)
      },
      lookupFoodItemForVolume: { foodItemIdentifier, volume in
        guard let nutritionFact = nutritionFacts[foodItemIdentifier] else {
          return nil
        }

        // Convert volume to mass via density
        let mass = volume.convertedToMass(usingDensity: nutritionFact.density)
        return nutritionFact.converted(toMass: mass)
      }
    )
  }
}
