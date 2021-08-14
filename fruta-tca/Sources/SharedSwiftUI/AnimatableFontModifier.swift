import SwiftUI

public struct AnimatableFontModifier: AnimatableModifier {
  public init(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) {
    self.size = size
    self.weight = weight
    self.design = design
  }

  var size: Double
  var weight: Font.Weight = .regular
  var design: Font.Design = .default

  public var animatableData: Double {
    get { size }
    set { size = newValue }
  }

  public func body(content: Content) -> some View {
    content
      .font(.system(size: size, weight: weight, design: design))
  }
}

extension View {
  public func animatableFont(
    size: Double,
    weight: Font.Weight = .regular,
    design: Font.Design = .default
  ) -> some View {
    self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
  }
}
