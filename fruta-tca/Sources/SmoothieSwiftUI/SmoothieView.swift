import ComposableArchitecture
import FavoriteSwiftUI
import IngredientCore
import IngredientSwiftUI
import SmoothieCore
import SwiftUI

public struct SmoothieView: View {
  let store: Store<SmoothieState, SmoothieAction>
  @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

  struct ViewState: Equatable {
    var smoothie: Smoothie
    var selectedIngredientID: Ingredient.ID?

    init(state: SmoothieState) {
      self.smoothie = state.smoothie
      self.selectedIngredientID = state.selectedIngredientID
    }
  }

  enum ViewAction: Equatable {
    case setIngredient(selection: Ingredient.ID?)
    case onAppear
  }

  public init(store: Store<SmoothieState, SmoothieAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init, action: SmoothieAction.init))
  }

  @Namespace private var namespace
  @State private var topmostIngredientID: Ingredient.ID?

  public var body: some View {
    container
      .background()
      .navigationTitle(viewStore.smoothie.title)
      .toolbar {
        FavoriteButton(store: store.scope(state: \.favorite, action: SmoothieAction.favorite))
      }
      .onAppear { viewStore.send(.onAppear) }
  }

  var container: some View {
    ZStack {
      ScrollView {
        content
          .accessibility(hidden: viewStore.selectedIngredientID != nil)
      }

      if viewStore.selectedIngredientID != nil {
        Rectangle().fill(.regularMaterial).ignoresSafeArea()
      }

      ForEach(viewStore.smoothie.menuIngredients) { measuredIngredient in
        let presenting = viewStore.selectedIngredientID == measuredIngredient.id
        IngredientCard(
          ingredient: measuredIngredient.ingredient,
          presenting: presenting,
          closeAction: deselectIngredient
        )
        .matchedGeometryEffect(id: measuredIngredient.id, in: namespace, isSource: presenting)
        .aspectRatio(0.75, contentMode: .fit)
        .shadow(color: Color.black.opacity(presenting ? 0.2 : 0), radius: 20, y: 10)
        .padding(20)
        .opacity(presenting ? 1 : 0)
        .zIndex(topmostIngredientID == measuredIngredient.id ? 1 : 0)
        .accessibilityElement(children: .contain)
        .accessibility(sortPriority: presenting ? 1 : 0)
        .accessibility(hidden: !presenting)
      }
    }
  }

  var content: some View {
    VStack(spacing: 0) {
      SmoothieHeaderView(smoothie: viewStore.smoothie)

      VStack(alignment: .leading) {
        Text("Ingredients")
          .font(Font.title).bold()
          .foregroundStyle(.secondary)

        LazyVGrid(
          columns: [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .top)],
          alignment: .center,
          spacing: 16
        ) {
          ForEach(viewStore.smoothie.menuIngredients) { measuredIngredient in
            let ingredient = measuredIngredient.ingredient
            let presenting = viewStore.selectedIngredientID == measuredIngredient.id
            Button(action: { select(ingredient: ingredient) }) {
              IngredientGraphic(
                ingredient: ingredient,
                mode: presenting ? .cardFront : .thumbnail
              )
              .matchedGeometryEffect(
                id: measuredIngredient.id,
                in: namespace,
                isSource: !presenting
              )
              .contentShape(Rectangle())
            }
            .buttonStyle(.squishable(fadeOnPress: false))
            .aspectRatio(1, contentMode: .fit)
            .zIndex(topmostIngredientID == measuredIngredient.id ? 1 : 0)
            .accessibility(label: Text(
              "\(ingredient.name) Ingredient",
              comment: "Accessibility label for collapsed ingredient card in smoothie overview"
            ))
          }
        }
      }.padding()
    }
  }

  func select(ingredient: Ingredient) {
    topmostIngredientID = ingredient.id
    viewStore.send(.setIngredient(selection: ingredient.id), animation: .openCard)
  }

  func deselectIngredient() {
    viewStore.send(.setIngredient(selection: nil), animation: .closeCard)
  }
}

extension SmoothieAction {
  init(action: SmoothieView.ViewAction) {
    switch action {
    case let .setIngredient(selection):
      self = .setIngredient(selection: selection)
    case .onAppear:
      self = .onAppear
    }
  }
}
