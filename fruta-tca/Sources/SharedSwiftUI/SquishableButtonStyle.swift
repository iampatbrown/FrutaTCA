import SwiftUI

public struct SquishableButtonStyle: ButtonStyle {
  var fadeOnPress = true

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .opacity(configuration.isPressed && fadeOnPress ? 0.75 : 1)
      .scaleEffect(configuration.isPressed ? 0.95 : 1)
  }
}

extension ButtonStyle where Self == SquishableButtonStyle {
  public static var squishable: SquishableButtonStyle {
    SquishableButtonStyle()
  }

  public static func squishable(fadeOnPress: Bool = true) -> SquishableButtonStyle {
    SquishableButtonStyle(fadeOnPress: fadeOnPress)
  }
}
