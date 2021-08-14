import Foundation

public struct Density: Equatable {
  public init(
    _ massAmount: Double,
    _ massUnit: UnitMass,
    per volumeAmount: Double,
    _ volumeUnit: UnitVolume
  ) {
    mass = Measurement(value: massAmount, unit: massUnit)
    volume = Measurement(value: volumeAmount, unit: volumeUnit)
  }

  public init(mass: Measurement<UnitMass>, volume: Measurement<UnitVolume>) {
    self.mass = mass
    self.volume = volume
  }

  public var mass: Measurement<UnitMass>
  public var volume: Measurement<UnitVolume>
}
