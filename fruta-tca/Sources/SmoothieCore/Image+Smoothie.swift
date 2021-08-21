import SwiftUI

extension Image {
  public init(_ smoothie: Smoothie) {
    // TODO: inject bundle
    self = Image(smoothie.id, bundle: Bundle.module, label: Text(smoothie.title))
      .renderingMode(.original)
  }
}
