import Foundation

extension NutritionFact {
  public static func + (lhs: Self, rhs: Self) -> Self {
    // Calculate combined mass, volume and density
    let totalMass = lhs.referenceMass + rhs.referenceMass
    let lhsVolume = lhs.referenceMass.convertedToVolume(usingDensity: lhs.density)
    let rhsVolume = lhs.referenceMass.convertedToVolume(usingDensity: lhs.density)
    let totalVolume = lhsVolume + rhsVolume

    return Self(
      identifier: "",
      localizedFoodItemName: "",
      density: Density(mass: totalMass, volume: totalVolume),
      referenceMass: totalMass,
      saturatedFat: lhs.saturatedFat + rhs.saturatedFat,
      monounsaturatedFat: lhs.monounsaturatedFat + rhs.monounsaturatedFat,
      polyunsaturatedFat: lhs.polyunsaturatedFat + rhs.polyunsaturatedFat,
      cholesterol: lhs.cholesterol + rhs.cholesterol,
      sodium: lhs.sodium + rhs.sodium,
      totalCarbohydrates: lhs.totalCarbohydrates + rhs.totalCarbohydrates,
      dietaryFiber: lhs.dietaryFiber + rhs.dietaryFiber,
      sugar: lhs.sugar + rhs.sugar,
      protein: lhs.protein + rhs.protein,
      calcium: lhs.calcium + rhs.calcium,
      potassium: lhs.potassium + rhs.potassium,
      vitaminA: lhs.vitaminA + rhs.vitaminA,
      vitaminC: lhs.vitaminC + rhs.vitaminC,
      iron: lhs.iron + rhs.iron
    )
  }

  public func converted(toVolume newReferenceVolume: Measurement<UnitVolume>) -> Self {
    let newRefMassInCups = newReferenceVolume.converted(to: .cups).value
    let oldRefMassInCups = referenceMass.convertedToVolume(usingDensity: density).value
    guard oldRefMassInCups > 0 else { return .zero }
    let scaleFactor = newRefMassInCups / oldRefMassInCups

    return Self(
      identifier: identifier,
      localizedFoodItemName: localizedFoodItemName,
      density: density,
      referenceMass: referenceMass * scaleFactor,
      saturatedFat: saturatedFat * scaleFactor,
      monounsaturatedFat: monounsaturatedFat * scaleFactor,
      polyunsaturatedFat: polyunsaturatedFat * scaleFactor,
      cholesterol: cholesterol * scaleFactor,
      sodium: sodium * scaleFactor,
      totalCarbohydrates: totalCarbohydrates * scaleFactor,
      dietaryFiber: dietaryFiber * scaleFactor,
      sugar: sugar * scaleFactor,
      protein: protein * scaleFactor,
      calcium: calcium * scaleFactor,
      potassium: potassium * scaleFactor,
      vitaminA: vitaminA * scaleFactor,
      vitaminC: vitaminC * scaleFactor,
      iron: iron * scaleFactor
    )
  }

  public func converted(toMass newReferenceMass: Measurement<UnitMass>) -> Self {
    let newRefMassInGrams = newReferenceMass.converted(to: .grams).value
    let oldRefMassInGrams = referenceMass.converted(to: .grams).value
    guard oldRefMassInGrams > 0 else { return .zero }
    let scaleFactor = newRefMassInGrams / oldRefMassInGrams
    return Self(
      identifier: identifier,
      localizedFoodItemName: localizedFoodItemName,
      density: density,
      referenceMass: newReferenceMass,
      saturatedFat: saturatedFat * scaleFactor,
      monounsaturatedFat: monounsaturatedFat * scaleFactor,
      polyunsaturatedFat: polyunsaturatedFat * scaleFactor,
      cholesterol: cholesterol * scaleFactor,
      sodium: sodium * scaleFactor,
      totalCarbohydrates: totalCarbohydrates * scaleFactor,
      dietaryFiber: dietaryFiber * scaleFactor,
      sugar: sugar * scaleFactor,
      protein: protein * scaleFactor,
      calcium: calcium * scaleFactor,
      potassium: potassium * scaleFactor,
      vitaminA: vitaminA * scaleFactor,
      vitaminC: vitaminC * scaleFactor,
      iron: iron * scaleFactor
    )
  }

  public func amount(_ mass: Measurement<UnitMass>) -> Self {
    converted(toMass: mass)
  }

  public func amount(_ volume: Measurement<UnitVolume>) -> Self {
    let mass = volume.convertedToMass(usingDensity: density)
    return converted(toMass: mass)
  }
}
