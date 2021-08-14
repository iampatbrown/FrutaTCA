import Foundation
import NutritionFactCore

public struct Ingredient: Equatable, Identifiable {
  public let id: String
  public let name: String
  public var nutritionFact: NutritionFact?

  internal init(
    id: String,
    name: String,
    nutritionFact: NutritionFact? = nil
  ) {
    self.id = id
    self.name = name
    self.nutritionFact = nutritionFact
  }
}

extension Ingredient {
  public static let avocado = Self(id: "avocado", name: "Avocado")
  public static let almondMilk = Self(id: "almond-milk", name: "Almond Milk")
  public static let banana = Self(id: "banana", name: "Banana")
  public static let blueberry = Self(id: "blueberry", name: "Blueberry")
  public static let carrot = Self(id: "carrot", name: "Carrot")
  public static let chocolate = Self(id: "chocolate", name: "Chocolate")
  public static let coconut = Self(id: "coconut", name: "Coconut")
  public static let kiwi = Self(id: "kiwi", name: "Kiwi")
  public static let lemon = Self(id: "lemon", name: "Lemon")
  public static let mango = Self(id: "mango", name: "Mango")
  public static let orange = Self(id: "orange", name: "Orange")
  public static let papaya = Self(id: "papaya", name: "Papaya")
  public static let peanutButter = Self(id: "peanut-butter", name: "Peanut Butter")
  public static let pineapple = Self(id: "pineapple", name: "Pineapple")
  public static let raspberry = Self(id: "raspberry", name: "Raspberry")
  public static let spinach = Self(id: "spinach", name: "Spinach")
  public static let strawberry = Self(id: "strawberry", name: "Strawberry")
  public static let water = Self(id: "water", name: "Water")
  public static let watermelon = Self(id: "watermelon", name: "Watermelon")
}

extension Ingredient {
  public static var all: [Ingredient] {
    [
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
//      .water,
      .watermelon,
    ]
  }

  public static func suggestions(for searchQuery: String) -> [Ingredient] {
    all.filter {
      $0.name.localizedCaseInsensitiveContains(searchQuery) &&
        $0.name.localizedCaseInsensitiveCompare(searchQuery) != .orderedSame
    }
  }
}
