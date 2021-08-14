import Foundation
import NutritionFactCore

extension NutritionFactClient {
  public static let alwaysBanana = Self(
    lookupFoodItemForMass: { _, _ in return .banana },
    lookupFoodItemForVolume: { _, _ in return .banana }
  )
}
