import SharedSwiftUI
import SwiftUI

public struct IngredientCard: View {
  var ingredient: Ingredient
  var presenting: Bool
  var closeAction: () -> Void = {}

  @State private var visibleSide = FlipViewSide.front

  public init(
    ingredient: Ingredient,
    presenting: Bool,
    closeAction: @escaping () -> Void = {}
  ) {
    self.ingredient = ingredient
    self.presenting = presenting
    self.closeAction = closeAction
  }

  public var body: some View {
    FlipView(
      visibleSide: visibleSide,
      front: {
        IngredientGraphic(
          ingredient: ingredient,
          mode: presenting ? .cardFront : .thumbnail,
          closeAction: closeAction,
          flipAction: flipCard
        )
      },
      back: {
        IngredientGraphic(
          ingredient: ingredient,
          mode: .cardBack,
          closeAction: closeAction,
          flipAction: flipCard
        )
      }
    )
    .contentShape(Rectangle())
    .animation(.flipCard, value: visibleSide)
  }

  func flipCard() {
    visibleSide.toggle()
  }
}
