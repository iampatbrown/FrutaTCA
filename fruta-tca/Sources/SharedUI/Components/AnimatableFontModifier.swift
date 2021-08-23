/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A modifier that can animate a font's size changing over time.
 */

import SwiftUI

public struct AnimatableFontModifier: AnimatableModifier {
  public var size: Double
  public var weight: Font.Weight = .regular
  public var design: Font.Design = .default

  public init(
    size: Double,
    weight: Font.Weight = .regular,
    design: Font.Design = .default
  ) {
    self.size = size
    self.weight = weight
    self.design = design
  }

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
  public func animatableFont(size: Double, weight: Font.Weight = .regular, design: Font.Design = .default) -> some View {
    self.modifier(AnimatableFontModifier(size: size, weight: weight, design: design))
  }
}
