import IngredientCore
import SwiftUI

extension IngredientGraphic {
  public struct Style {
    public var title = Title()
    public var thumbnailCrop = Crop()
    public var cardCrop = Crop()
    public var shape = RoundedRectangle(cornerRadius: 16, style: .continuous)

    public struct Title {
      public var color = Color.black
      public var rotation = Angle.degrees(0)
      public var offset = CGSize.zero
      public var blendMode = BlendMode.normal
      public var opacity: Double = 1
      public var fontSize: Double = 1
    }

    public struct Crop {
      public var xOffset: Double = 0
      public var yOffset: Double = 0
      public var scale: Double = 1

      public var offset: CGSize {
        CGSize(width: xOffset, height: yOffset)
      }
    }
  }
}

extension IngredientGraphic.Style {
  public init(_ ingredient: Ingredient) {
    self = Self.styles[ingredient.id] ?? Self()
  }

  static let styles: [Ingredient.ID: Self] = [
    Ingredient.avocado.id: avocado,
    Ingredient.almondMilk.id: almondMilk,
    Ingredient.banana.id: banana,
    Ingredient.blueberry.id: blueberry,
    Ingredient.carrot.id: carrot,
    Ingredient.chocolate.id: chocolate,
    Ingredient.coconut.id: coconut,
    Ingredient.kiwi.id: kiwi,
    Ingredient.lemon.id: lemon,
    Ingredient.mango.id: mango,
    Ingredient.orange.id: orange,
    Ingredient.papaya.id: papaya,
    Ingredient.peanutButter.id: peanutButter,
    Ingredient.pineapple.id: pineapple,
    Ingredient.raspberry.id: raspberry,
    Ingredient.spinach.id: spinach,
    Ingredient.strawberry.id: strawberry,
    Ingredient.water.id: water,
    Ingredient.watermelon.id: watermelon,
  ]

  static let avocado = Self(
    title: Title(
      color: .brown,
      offset: CGSize(width: 0, height: 20),
      blendMode: .plusDarker,
      opacity: 0.4,
      fontSize: 60
    )
  )

  static let almondMilk = Self(
    title: Title(
      offset: CGSize(width: 0, height: -140),
      blendMode: .overlay,
      fontSize: 40
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  static let banana = Self(
    title: Title(
      rotation: Angle.degrees(-30),
      offset: CGSize(width: 0, height: 0),
      blendMode: .overlay,
      fontSize: 70
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  static let blueberry = Self(
    title: Title(
      color: .white,
      offset: CGSize(width: 0, height: 100),
      opacity: 0.5,
      fontSize: 45
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 2)
  )

  static let carrot = Self(
    title: Title(
      rotation: Angle.degrees(-90),
      offset: CGSize(width: -120, height: 100),
      blendMode: .plusDarker,
      opacity: 0.3,
      fontSize: 70
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1.2)
  )

  static let chocolate = Self(
    title: Title(
      color: .brown,
      rotation: Angle.degrees(-11),
      offset: CGSize(width: 0, height: 10),
      blendMode: .plusDarker,
      opacity: 0.8,
      fontSize: 45
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  static let coconut = Self(
    title: Title(
      color: .brown,
      offset: CGSize(width: 40, height: 110),
      blendMode: .plusDarker,
      opacity: 0.8,
      fontSize: 36
    ),
    thumbnailCrop: Crop(scale: 1.5)
  )

  static let kiwi = Self(
    title: Title(
      offset: CGSize(width: 0, height: 0),
      blendMode: .overlay,
      fontSize: 140
    ),
    thumbnailCrop: Crop(scale: 1.1)
  )

  static let lemon = Self(
    title: Title(
      rotation: Angle.degrees(-9),
      offset: CGSize(width: 15, height: 90),
      blendMode: .overlay,
      fontSize: 80
    ),
    thumbnailCrop: Crop(scale: 1.1)
  )

  static let mango = Self(
    title: Title(
      color: .orange,
      offset: CGSize(width: 0, height: 20),
      blendMode: .plusLighter,
      fontSize: 70
    )
  )

  static let orange = Self(
    title: Title(
      rotation: Angle.degrees(-90),
      offset: CGSize(width: -130, height: -60),
      blendMode: .overlay,
      fontSize: 80
    ),
    thumbnailCrop: Crop(yOffset: -15, scale: 2)
  )

  static let papaya = Self(
    title: Title(
      offset: CGSize(width: -20, height: 20),
      blendMode: .overlay,
      fontSize: 70
    ),
    thumbnailCrop: Crop(scale: 1)
  )

  static let peanutButter = Self(
    title: Title(
      offset: CGSize(width: 0, height: 190),
      blendMode: .overlay,
      fontSize: 35
    ),
    thumbnailCrop: Crop(yOffset: -20, scale: 1.2)
  )

  static let pineapple = Self(
    title: Title(
      color: .yellow,
      offset: CGSize(width: 0, height: 90),
      blendMode: .plusLighter,
      opacity: 0.5,
      fontSize: 55
    )
  )

  static let raspberry = Self(
    title: Title(
      color: .pink,
      blendMode: .plusLighter,
      fontSize: 50
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1.5)
  )

  static let spinach = Self(
    title: Title(
      offset: CGSize(width: 0, height: -150),
      blendMode: .overlay,
      fontSize: 70
    ),
    thumbnailCrop: Crop(yOffset: 0, scale: 1)
  )

  static let strawberry = Self(
    title: Title(
      color: .white,
      offset: CGSize(width: 35, height: -5),
      blendMode: .softLight,
      opacity: 0.7,
      fontSize: 30
    ),
    thumbnailCrop: Crop(scale: 2.5),
    cardCrop: Crop(xOffset: -110, scale: 1.35)
  )

  static let water = Self(
    title: Title(
      color: .blue,
      offset: CGSize(width: 0, height: 150),
      opacity: 0.2,
      fontSize: 50
    ),
    thumbnailCrop: Crop(yOffset: -10, scale: 1.2)
  )

  static let watermelon = Self(
    title: Title(
      rotation: Angle.degrees(-50),
      offset: CGSize(width: -80, height: -50),
      blendMode: .overlay,
      fontSize: 25
    ),
    thumbnailCrop: Crop(yOffset: -10, scale: 1.2)
  )
}
