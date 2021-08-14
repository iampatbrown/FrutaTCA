import Foundation

extension Measurement where UnitType == UnitVolume {
  public static func cups(_ cups: Double) -> Self {
    Self(value: cups, unit: .cups)
  }

  public static func tablespoons(_ tablespoons: Double) -> Self {
    Self(value: tablespoons, unit: .tablespoons)
  }
}

extension Measurement where UnitType == UnitMass {
  public static func grams(_ grams: Double) -> Self {
    Self(value: grams, unit: .grams)
  }
}

extension Measurement where UnitType == UnitVolume {
  public func convertedToMass(usingDensity density: Density) -> Measurement<UnitMass> {
    let densityLiters = density.volume.converted(to: .liters).value
    let liters = converted(to: .liters).value
    let scale = liters / densityLiters
    return density.mass * scale
  }
}

extension Measurement where UnitType == UnitMass {
  public func convertedToVolume(usingDensity density: Density) -> Measurement<UnitVolume> {
    let densityKilograms = density.mass.converted(to: .kilograms).value
    let kilograms = converted(to: .kilograms).value
    let scale = kilograms / densityKilograms
    return density.volume * scale
  }
}

// probably doesn't belong here
extension Measurement {
  public func localizedSummary(
    unitStyle: MeasurementFormatter.UnitStyle = .long,
    unitOptions: MeasurementFormatter.UnitOptions = [.providedUnit]
  ) -> String {
    let formatter = MeasurementFormatter()
    formatter.unitStyle = unitStyle
    formatter.unitOptions = unitOptions
    return formatter.string(from: self)
  }
}
