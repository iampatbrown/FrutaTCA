import Foundation

public struct SmoothieState: Equatable, Identifiable {
  public var id: String
  public var title: String
  public var description: AttributedString
  public var measuredIngredients: [String]
  public var hasFreeRecipe: Bool
  public var isFavorite: Bool
}
