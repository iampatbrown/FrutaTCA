import AuthenticationClient
import ComposableArchitecture
import OrdersFeature // Not sure if this should just be OrdersCore or OrdersFeature... also Order vs Orders?
import SharedModels
import SharedUI
import SwiftUI

public struct SmoothieState: Equatable, Identifiable {
  public var account: Account?
  public var order: Order?
  public var smoothie: Smoothie
  public var presentingOrderPlacedSheet: Bool
  public var presentingSecurityAlert: Bool
  public var selectedIngredientID: Ingredient.ID?
  public var topmostIngredientID: Ingredient.ID?
  public var isFavorite: Bool

  public init(
    account: Account? = nil,
    order: Order? = nil,
    smoothie: Smoothie,
    presentingOrderPlacedSheet: Bool = false,
    presentingSecurityAlert: Bool = false,
    selectedIngredientID: Ingredient.ID? = nil,
    topmostIngredientID: Ingredient.ID? = nil,
    isFavorite: Bool = false
  ) {
    self.account = account
    self.order = order
    self.smoothie = smoothie
    self.presentingOrderPlacedSheet = presentingOrderPlacedSheet
    self.presentingSecurityAlert = presentingSecurityAlert
    self.selectedIngredientID = selectedIngredientID
    self.topmostIngredientID = topmostIngredientID
    self.isFavorite = isFavorite
  }

  public var id: Smoothie.ID { smoothie.id }

  var orderPlaced: OrderPlacedState {
    get {
      .init(account: self.account, order: self.order)
    }
    set {
      self.account = newValue.account
      self.order = newValue.order
    }
  }
}

public enum SmoothieAction: Equatable {
  case redeemSmoothie
  case orderSmoothie
  case addOrderToAccount

  case select(Ingredient)
  case deselectIngredient

  case binding(BindingAction<SmoothieState>)
  case orderPlaced(OrderPlacedAction)
}

public struct SmoothieEnvironment {
  public var authentication: AuthenticationClient

  public init(authentication: AuthenticationClient) {
    self.authentication = authentication
  }
}

public let smoothieReducer = Reducer<SmoothieState, SmoothieAction, SmoothieEnvironment>.combine(
  orderPlacedReducer.pullback(
    state: \.orderPlaced,
    action: /SmoothieAction.orderPlaced,
    environment: { .init(authentication: $0.authentication) }
  ).debug(),
  Reducer { state, action, environment in
    switch action {
    case .orderSmoothie:
      // TODO: alert for isApplePayEnabled
      state.order = Order(smoothie: state.smoothie, points: 1, isReady: false)
      state.presentingOrderPlacedSheet = true
      return Effect(value: .addOrderToAccount)

    case .redeemSmoothie:
      guard var account = state.account, account.canRedeemFreeSmoothie else { return .none }
      account.pointsSpent += 10
      state.account = account
      return Effect(value: .orderSmoothie)

    case .addOrderToAccount:
      guard let order = state.order else { return .none }
      state.account?.appendOrder(order)
      return .none

    case let .select(ingredient):
      state.topmostIngredientID = ingredient.id
      return Effect(value: .binding(.set(\.selectedIngredientID, ingredient.id)))
        .receive(on: DispatchQueue.main.animation(.openCard))
        .eraseToEffect()

    case .deselectIngredient:
      state.selectedIngredientID = nil
      return .none

    case .binding:
      return .none

    case .orderPlaced:
      return .none
    }
  }
).binding(action: /SmoothieAction.binding)

public struct SmoothieView: View {
  let store: Store<SmoothieState, SmoothieAction>
  @ObservedObject var viewStore: ViewStore<SmoothieState, SmoothieAction>

  public init(store: Store<SmoothieState, SmoothieAction>) {
    self.store = store
    self.viewStore = ViewStore(self.store)
  }

  @Namespace private var namespace

  public var body: some View {
    container
    #if os(macOS)
      .frame(minWidth: 500, idealWidth: 700, maxWidth: .infinity, minHeight: 400, maxHeight: .infinity)
    #endif
    .background()
      .navigationTitle(viewStore.smoothie.title)
      .toolbar {
        SmoothieFavoriteButton(
          isFavorite: viewStore.binding(keyPath: \.isFavorite, send: SmoothieAction.binding)
        )
      }
      .sheet(
        isPresented: viewStore.binding(keyPath: \.presentingOrderPlacedSheet, send: SmoothieAction.binding)
      ) {
        OrderPlacedView(
          store: self.store
            .scope(state: \.orderPlaced, action: SmoothieAction.orderPlaced)
        )
        #if os(macOS)
          .clipped()
          .toolbar {
            ToolbarItem(placement: .confirmationAction) {
              Button { viewStore.send(.binding(.set(\.presentingOrderPlacedSheet, false))) } label: {
                Text("Done", comment: "Button to dismiss the confirmation sheet after placing an order")
              }
            }
          }
        #else
          .overlay(alignment: .topTrailing) {
            Button {
              viewStore.send(.binding(.set(\.presentingOrderPlacedSheet, false)))
            } label: {
              Text("Done", comment: "Button to dismiss the confirmation sheet after placing an order")
            }
            .font(.body.bold())
            .buttonStyle(.capsule)
            .keyboardShortcut(.defaultAction)
            .padding()
          }
        #endif
      }
      .alert(
        isPresented: viewStore.binding(
          keyPath: \.presentingSecurityAlert,
          send: SmoothieAction.binding
        )
      ) {
        // TODO: Use TCAAlert
        Alert(
          title: Text(
            "Payments Disabled",
            comment: "Title of alert dialog when payments are disabled"
          ),
          message: Text(
            "The Fruta QR code was scanned too far from the shop, payments are disabled for your protection.",
            comment: "Explanatory text of alert dialog when payments are disabled"
          ),
          dismissButton: .default(Text(
            "OK",
            comment: "OK button of alert dialog when payments are disabled"
          ))
        )
      }
  }

  var container: some View {
    ZStack {
      ScrollView {
        content
        #if os(macOS)
          .frame(maxWidth: 600)
          .frame(maxWidth: .infinity)
        #endif
      }
      .safeAreaInset(edge: .bottom, spacing: 0) {
        bottomBar
      }
      .accessibility(hidden: viewStore.selectedIngredientID != nil)

      if viewStore.selectedIngredientID != nil {
        Rectangle().fill(.regularMaterial).ignoresSafeArea()
      }

      ForEach(viewStore.smoothie.menuIngredients) { measuredIngredient in
        let presenting = viewStore.selectedIngredientID == measuredIngredient.id
        IngredientCard(
          ingredient: measuredIngredient.ingredient,
          presenting: presenting,
          closeAction: { viewStore.send(.deselectIngredient, animation: .closeCard) }
        )
        .matchedGeometryEffect(id: measuredIngredient.id, in: namespace, isSource: presenting)
        .aspectRatio(0.75, contentMode: .fit)
        .shadow(color: Color.black.opacity(presenting ? 0.2 : 0), radius: 20, y: 10)
        .padding(20)
        .opacity(presenting ? 1 : 0)
        .zIndex(viewStore.topmostIngredientID == measuredIngredient.id ? 1 : 0)
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
        Text(
          "Ingredients.menu",
          tableName: "Ingredients",
          comment: "Ingredients in a smoothie. For languages that have different words for \"Ingredient\" based on semantic context."
        )
        .font(Font.title).bold()
        .foregroundStyle(.secondary)
//
        LazyVGrid(
          columns: [GridItem(.adaptive(minimum: 130), spacing: 16, alignment: .top)],
          alignment: .center,
          spacing: 16
        ) {
          ForEach(viewStore.smoothie.menuIngredients) { measuredIngredient in
            let ingredient = measuredIngredient.ingredient
            let presenting = viewStore.selectedIngredientID == measuredIngredient.id
            Button(action: { viewStore.send(.select(ingredient)) }) {
              IngredientGraphic(
                ingredient: measuredIngredient.ingredient,
                style: presenting ? .cardFront : .thumbnail
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
            .zIndex(viewStore.topmostIngredientID == measuredIngredient.id ? 1 : 0)
            .accessibility(label: Text(
              "\(ingredient.name) Ingredient",
              comment: "Accessibility label for collapsed ingredient card in smoothie overview"
            ))
          }
        }
      }
      .padding()
    }
  }

  var bottomBar: some View {
    VStack(spacing: 0) {
      Divider()
      Group {
        if let account = viewStore.account, account.canRedeemFreeSmoothie {
          RedeemSmoothieButton { viewStore.send(.redeemSmoothie) }
        } else {
          PaymentButton { viewStore.send(.orderSmoothie) }
        }
      }
      .padding(.horizontal, 40)
      .padding(.vertical, 16)
    }
    .background(.bar)
  }
}

struct SmoothieView_Previews: PreviewProvider {
  static var previews: some View {
    SmoothieView(
      store: Store(
        initialState: .init(smoothie: .berryBlue),
        reducer: .empty,
        environment: ()
      )
    )
  }
}
