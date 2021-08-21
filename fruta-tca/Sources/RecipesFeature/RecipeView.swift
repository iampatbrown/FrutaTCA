import ComposableArchitecture
import SmoothieCore
import SwiftUI

public struct RecipeView: View {
  let store: Store<RecipeState, RecipeAction>
  @ObservedObject var viewStore: ViewStore<RecipeState, RecipeAction>

  public init(store: Store<RecipeState, RecipeAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var backgroundColor: Color {
    #if os(iOS)
      return Color(uiColor: .secondarySystemBackground)
    #else
      return Color(nsColor: .textBackgroundColor)
    #endif
  }

  let shape = RoundedRectangle(cornerRadius: 24, style: .continuous)

  var recipeToolbar: some View {
    StepperView(
      value: viewStore.binding(get: \.smoothieCount, send: RecipeAction.smoothieCountChanged),
      label: "\(viewStore.smoothieCount) Smoothies",
      configuration: StepperView.Configuration(increment: 1, minValue: 1, maxValue: 9)
    )
    .frame(maxWidth: .infinity)
    .padding(20)
  }

  public var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Image(viewStore.smoothie)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(maxHeight: 300)
          .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
          .overlay {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
              .strokeBorder(.quaternary, lineWidth: 0.5)
          }
          .overlay(alignment: .bottom) { recipeToolbar }

        VStack(alignment: .leading) {
          Text("Ingredients")
            .font(Font.title).bold()
            .foregroundStyle(.secondary)

          VStack {
            ForEach(0 ..< viewStore.smoothie.measuredIngredients.count) { index in
              RecipeIngredientRow(
                measuredIngredient: viewStore.smoothie.measuredIngredients[index]
                  .scaled(by: Double(viewStore.smoothieCount))
              )
              .padding(.horizontal)
              if index < viewStore.smoothie.measuredIngredients.count - 1 {
                Divider()
              }
            }
          }
          .padding(.vertical)
          .background()
          .clipShape(shape)
          .overlay {
            shape.strokeBorder(.quaternary, lineWidth: 0.5)
          }
        }
      }
      .padding()
      .frame(minWidth: 200, idealWidth: 400, maxWidth: 400)
      .frame(maxWidth: .infinity)
    }
    .background { backgroundColor.ignoresSafeArea() }
    .navigationTitle(viewStore.smoothie.title)
    //  .toolbar { SmoothieFavoriteButton(smoothie: smoothie) }
  }
}
