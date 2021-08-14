import Foundation
import SwiftUI

extension Image {
  public init(_ unit: UnitMass) {
    // TODO: inject bundle
    self = Image(systemName: "scalemass.fill")
  }

  public init(_ unit: UnitVolume) {
    switch unit.symbol {
    // Icons included in the asset catalog
    case "cup", "gal", "qt", "tbsp", "tsp":
      self = Image(unit.symbol, bundle: Bundle.module)
    default:
      self = Image(systemName: "drop.fill")
    }
  }

  public init(_ unit: Unit) {
    if let unitMass = unit as? UnitMass {
      self = Image(unitMass)
    } else if let unitVolume = unit as? UnitVolume {
      self = Image(unitVolume)
    } else {
      self = Image(systemName: "gauge")
    }
  }
}
