import ComposableArchitecture
import SharedModels
import SwiftUI

public struct SmoothieState: Equatable, Identifiable {
  public var id: Smoothie.ID
  public var title: String
  public var description: AttributedString
  public var measuredIngredients: [MeasuredIngredient]
  public var hasFreeRecipe: Bool
  @BindableState public var isFavorite: Bool

  public var energy: Measurement<UnitEnergy>

  public init(
    id: Smoothie.ID,
    title: String,
    description: AttributedString,
    measuredIngredients: [MeasuredIngredient],
    hasFreeRecipe: Bool,
    isFavorite: Bool,
    energy: Measurement<UnitEnergy>
  ) {
    self.id = id
    self.title = title
    self.description = description
    self.measuredIngredients = measuredIngredients
    self.hasFreeRecipe = hasFreeRecipe
    self.isFavorite = isFavorite
    self.energy = energy
  }

  public var menuIngredients: [MeasuredIngredient] {
    measuredIngredients.filter { $0.id != "water" } // TODO: Use water id
  }
}

public enum SmoothieAction: Equatable, BindableAction {
  case toggleFavorite
  case binding(BindingAction<SmoothieState>)
}

public let smoothieReducer = Reducer<SmoothieState, SmoothieAction, Void> { state, action, _ in
  switch action {
  case .toggleFavorite:
    state.isFavorite.toggle()
    return .none
  case .binding:
    return .none
  }
}.binding()

struct SmoothieView: View {
  let store: Store<SmoothieState, SmoothieAction>
  @ObservedObject var viewStore: ViewStore<SmoothieState, SmoothieAction>

  init(store: Store<SmoothieState, SmoothieAction>) {
    self.store = store
    self.viewStore = ViewStore(self.store)
  }

  var body: some View {
    container
      .navigationTitle(viewStore.title)
      .toolbar {
        SmoothieFavoriteButton(isFavorite: viewStore.$isFavorite)
      }.sheet(isPresented: .constant(false)) {
        Text("OrderPlacedView") // TODO: Implement OrderPlacedView
      }.alert(isPresented: .constant(false)) {
        Alert(
          title: Text("Payments Disabled"),
          message: Text(
            "The Fruta QR code was scanned too far from the shop, payments are disabled for your protection."
          ),
          dismissButton: .default(Text("OK"))
        )
      }
  }

  var container: some View {
    ZStack {
      ScrollView {
        content
      }.safeAreaInset(edge: .bottom, spacing: 0) {
        bottomBar
      }
    }
  }

  var content: some View {
    VStack(spacing: 0) {
      SmoothieHeaderView(state: viewStore.state)

      VStack(alignment: .leading) {
        Text("Ingredients")
          .font(Font.title).bold()
          .foregroundStyle(.secondary)

        LazyVGrid(
          columns: [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .top)],
          alignment: .center,
          spacing: 16
        ) {
          ForEach(viewStore.menuIngredients) { measuredIngredient in
            Text(measuredIngredient.ingredient.name)
          }
        }
      }.padding()
    }
  }

  var bottomBar: some View {
    Text("Bottom Bar") // TODO: Implement RedeemSmoothie + PaymentButton
  }
}
