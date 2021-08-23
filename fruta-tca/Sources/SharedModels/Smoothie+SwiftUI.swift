import SwiftUI

// MARK: - SwiftUI.Image

extension Smoothie {
  public var image: Image {
    Image("smoothie/\(id)", bundle: .module, label: Text(title))
      .renderingMode(.original)
  }
}
