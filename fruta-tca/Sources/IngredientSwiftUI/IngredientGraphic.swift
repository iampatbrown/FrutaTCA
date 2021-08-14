import IngredientCore
import NutritionFactSwiftUI
import SharedSwiftUI
import SwiftUI

public struct IngredientGraphic: View {
  var ingredient: Ingredient
  var mode: DisplayMode
  var style: Style
  var closeAction: () -> Void = {}
  var flipAction: () -> Void = {}

  public enum DisplayMode {
    case cardFront
    case cardBack
    case thumbnail
  }

  var displayingAsCard: Bool { mode != .thumbnail }

  public init(
    ingredient: Ingredient,
    mode: DisplayMode,
    style: Style? = nil,
    closeAction: @escaping () -> Void = {},
    flipAction: @escaping () -> Void = {}
  ) {
    self.ingredient = ingredient
    self.mode = mode
    self.closeAction = closeAction
    self.flipAction = flipAction
    self.style = style ?? Style(ingredient) // probably change this
  }

  public var body: some View {
    ZStack {
      image

      if mode != .cardBack { title }

      if mode == .cardFront {
        cardControls(for: .front)
          .foregroundStyle(style.title.color)
          .opacity(style.title.opacity)
          .blendMode(style.title.blendMode)
      }

      if mode == .cardBack {
        ZStack {
          if let nutritionFact = ingredient.nutritionFact {
            NutritionFactView(nutritionFact: nutritionFact)
              .padding(.bottom, 70)
          }
          cardControls(for: .back)
        }
        .background(.thinMaterial)
      }
    }
    .frame(minWidth: 130, maxWidth: 400, maxHeight: 500)
    .compositingGroup()
    .clipShape(style.shape)
    .overlay {
      style.shape
        .inset(by: 0.5)
        .stroke(.quaternary, lineWidth: 0.5)
    }
    .contentShape(style.shape)
    .accessibilityElement(children: .contain)
  }

  var image: some View {
    GeometryReader { geo in
      Image(ingredient)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: geo.size.width, height: geo.size.height)
        .scaleEffect(displayingAsCard ? style.cardCrop.scale : style.thumbnailCrop.scale)
        .offset(displayingAsCard ? style.cardCrop.offset : style.thumbnailCrop.offset)
        .frame(width: geo.size.width, height: geo.size.height)
        .scaleEffect(x: mode == .cardBack ? -1 : 1)
    }
    .accessibility(hidden: true)
  }

  var title: some View {
    Text(ingredient.name.uppercased())
      .padding(.horizontal, 8)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .lineLimit(2)
      .multilineTextAlignment(.center)
      .foregroundStyle(style.title.color)
      .rotationEffect(displayingAsCard ? style.title.rotation : .degrees(0))
      .opacity(style.title.opacity)
      .blendMode(style.title.blendMode)
      .animatableFont(size: displayingAsCard ? style.title.fontSize : 40, weight: .bold)
      .minimumScaleFactor(0.25)
      .offset(displayingAsCard ? style.title.offset : .zero)
  }

  func cardControls(for side: FlipViewSide) -> some View {
    VStack {
      if side == .front {
        CardActionButton(label: "Close", systemImage: "xmark.circle.fill", action: closeAction)
          .scaleEffect(displayingAsCard ? 1 : 0.5)
          .opacity(displayingAsCard ? 1 : 0)
      }
      Spacer()
      CardActionButton(
        label: side == .front ? "Open Nutrition Facts" : "Close Nutrition Facts",
        systemImage: side == .front ? "info.circle.fill" : "arrow.left.circle.fill",
        action: flipAction
      )
      .scaleEffect(displayingAsCard ? 1 : 0.5)
      .opacity(displayingAsCard ? 1 : 0)
    }
    .frame(maxWidth: .infinity, alignment: .trailing)
  }
}

struct IngredientGraphic_Previews: PreviewProvider {
  static let ingredient = Ingredient.orange
  static var previews: some View {
    Group {
      IngredientGraphic(ingredient: ingredient, mode: .thumbnail)
        .frame(width: 180, height: 180)
        .previewDisplayName("Thumbnail")

      IngredientGraphic(ingredient: ingredient, mode: .cardFront)
        .aspectRatio(0.75, contentMode: .fit)
        .frame(width: 500, height: 600)
        .previewDisplayName("Card Front")

      IngredientGraphic(ingredient: ingredient, mode: .cardBack)
        .aspectRatio(0.75, contentMode: .fit)
        .frame(width: 500, height: 600)
        .previewDisplayName("Card Back")
    }
    .previewLayout(.sizeThatFits)
  }
}
