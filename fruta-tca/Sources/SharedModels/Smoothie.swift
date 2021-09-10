import Foundation

public struct Smoothie: Equatable, Identifiable {
  public var id: String
  public var title: String
  public var description: AttributedString
  public var measuredIngredients: [MeasuredIngredient]
}
