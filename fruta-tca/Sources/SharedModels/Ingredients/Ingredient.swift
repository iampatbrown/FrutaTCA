public struct Ingredient: Identifiable, Codable {
  public var id: String
  public var name: String
  public var title = CardTitle()
  public var thumbnailCrop = Crop()
  public var cardCrop = Crop()

  enum CodingKeys: String, CodingKey {
    case id
    case name
  }
}

extension Ingredient: Equatable {
  public static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
    lhs.id == rhs.id
  }
}

// MARK: - All Ingredients

extension Ingredient {
  public static let all: [Ingredient] = [
    .avocado,
    .almondMilk,
    .banana,
    .blueberry,
    .carrot,
    .chocolate,
    .coconut,
    .kiwi,
    .lemon,
    .mango,
    .orange,
    .papaya,
    .peanutButter,
    .pineapple,
    .raspberry,
    .spinach,
    .strawberry,
    .watermelon,
  ]

  public init?(for id: Ingredient.ID) {
    guard let result = Ingredient.all.first(where: { $0.id == id }) else {
      return nil
    }
    self = result
  }
}
