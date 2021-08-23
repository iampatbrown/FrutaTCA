import SwiftUI

// MARK: - SwiftUI

extension Ingredient {
  /// Defines how the `Ingredient`'s title should be displayed in card mode
  public struct CardTitle {
    public var color = Color.black
    public var rotation = Angle.degrees(0)
    public var offset = CGSize.zero
    public var blendMode = BlendMode.normal
    public var opacity: Double = 1
    public var fontSize: Double = 1
  }

  /// Defines a state for the `Ingredient` to transition from when changing between card and thumbnail
  public struct Crop {
    public var xOffset: Double = 0
    public var yOffset: Double = 0
    public var scale: Double = 1

    public var offset: CGSize {
      CGSize(width: xOffset, height: yOffset)
    }
  }

  /// The `Ingredient`'s image, useful for backgrounds or thumbnails
  public var image: Image {
    Image("ingredient/\(id)", bundle: .module, label: Text(name))
      .renderingMode(.original)
  }
}

// MARK: - All Recipes

extension Ingredient {
  public static let avocado = Ingredient(
    id: "avocado",
    name: String(localized: "Avocado", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .brown,
      offset: CGSize(width: 0, height: 20),
      blendMode: .plusDarker,
      opacity: 0.4,
      fontSize: 60
    )
  )

  public static let almondMilk = Ingredient(
    id: "almond-milk",
    name: String(localized: "Almond Milk", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      offset: CGSize(width: 0, height: -140),
      blendMode: .overlay,
      fontSize: 40
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  public static let banana = Ingredient(
    id: "banana",
    name: String(localized: "Banana", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      rotation: Angle.degrees(-30),
      offset: CGSize(width: 0, height: 0),
      blendMode: .overlay,
      fontSize: 70
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  public static let blueberry = Ingredient(
    id: "blueberry",
    name: String(localized: "Blueberry", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .white,
      offset: CGSize(width: 0, height: 100),
      opacity: 0.5,
      fontSize: 45
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 2)
  )

  public static let carrot = Ingredient(
    id: "carrot",
    name: String(localized: "Carrot", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      rotation: Angle.degrees(-90),
      offset: CGSize(width: -120, height: 100),
      blendMode: .plusDarker,
      opacity: 0.3,
      fontSize: 70
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1.2)
  )

  public static let chocolate = Ingredient(
    id: "chocolate",
    name: String(localized: "Chocolate", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .brown,
      rotation: Angle.degrees(-11),
      offset: CGSize(width: 0, height: 10),
      blendMode: .plusDarker,
      opacity: 0.8,
      fontSize: 45
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  public static let coconut = Ingredient(
    id: "coconut",
    name: String(localized: "Coconut", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .brown,
      offset: CGSize(width: 40, height: 110),
      blendMode: .plusDarker,
      opacity: 0.8,
      fontSize: 36
    ),
    thumbnailCrop: Crop(scale: 1.5)
  )

  public static let kiwi = Ingredient(
    id: "kiwi",
    name: String(localized: "Kiwi", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      offset: CGSize(width: 0, height: 0),
      blendMode: .overlay,
      fontSize: 140
    ),
    thumbnailCrop: Crop(scale: 1.1)
  )

  public static let lemon = Ingredient(
    id: "lemon",
    name: String(localized: "Lemon", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      rotation: Angle.degrees(-9),
      offset: CGSize(width: 15, height: 90),
      blendMode: .overlay,
      fontSize: 80
    ),
    thumbnailCrop: Crop(scale: 1.1)
  )

  public static let mango = Ingredient(
    id: "mango",
    name: String(localized: "Mango", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .orange,
      offset: CGSize(width: 0, height: 20),
      blendMode: .plusLighter,
      fontSize: 70
    )
  )

  public static let orange = Ingredient(
    id: "orange",
    name: String(localized: "Orange", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      rotation: Angle.degrees(-90),
      offset: CGSize(width: -130, height: -60),
      blendMode: .overlay,
      fontSize: 80
    ),
    thumbnailCrop: Crop(yOffset: -15, scale: 2)
  )

  public static let papaya = Ingredient(
    id: "papaya",
    name: String(localized: "Papaya", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      offset: CGSize(width: -20, height: 20),
      blendMode: .overlay,
      fontSize: 70
    ),
    thumbnailCrop: Crop(scale: 1)
  )

  public static let peanutButter = Ingredient(
    id: "peanut-butter",
    name: String(localized: "Peanut Butter", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      offset: CGSize(width: 0, height: 190),
      blendMode: .overlay,
      fontSize: 35
    ),
    thumbnailCrop: Crop(yOffset: -20, scale: 1.2)
  )

  public static let pineapple = Ingredient(
    id: "pineapple",
    name: String(localized: "Pineapple", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .yellow,
      offset: CGSize(width: 0, height: 90),
      blendMode: .plusLighter,
      opacity: 0.5,
      fontSize: 55
    )
  )

  public static let raspberry = Ingredient(
    id: "raspberry",
    name: String(localized: "Raspberry", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .pink,
      blendMode: .plusLighter,
      fontSize: 50
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1.5)
  )

  public static let spinach = Ingredient(
    id: "spinach",
    name: String(localized: "Spinach", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      offset: CGSize(width: 0, height: -150),
      blendMode: .overlay,
      fontSize: 70
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  public static let strawberry = Ingredient(
    id: "strawberry",
    name: String(localized: "Strawberry", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .white,
      offset: CGSize(width: 35, height: -5),
      blendMode: .softLight,
      opacity: 0.7,
      fontSize: 30
    ),
    thumbnailCrop: Crop(scale: 2.5),
    cardCrop: Crop(xOffset: -110, scale: 1.35)
  )

  public static let water = Ingredient(
    id: "water",
    name: String(localized: "Water", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      color: .blue,
      offset: CGSize(width: 0, height: 150),
      opacity: 0.2,
      fontSize: 50
    ),
    thumbnailCrop: Crop(yOffset: -10, scale: 1.2)
  )

  public static let watermelon = Ingredient(
    id: "watermelon",
    name: String(localized: "Watermelon", table: "Ingredients", comment: "Ingredient name"),
    title: CardTitle(
      rotation: Angle.degrees(-50),
      offset: CGSize(width: -80, height: -50),
      blendMode: .overlay,
      fontSize: 25
    ),
    thumbnailCrop: Crop(yOffset: -10, scale: 1.2)
  )
}
