import AccountCore
import ComposableArchitecture
import SwiftUI

public struct OrderPlacedState: Equatable {
  var account: AccountState
  var order: OrderState
}

public enum OrderPlacedAction: Equatable {
  case account(AccountAction)
}

public struct OrderPlacedView: View {
  let store: Store<OrderPlacedState, OrderPlacedAction>
  @ObservedObject var viewStore: ViewStore<ViewState, ViewAction>

  struct ViewState: Equatable {
    var isGuest: Bool
    var orderIsReady: Bool
  }

  enum ViewAction {
    case authenticate(String)
  }

  public init(store: Store<OrderPlacedState, OrderPlacedAction>) {
    self.store = store
    self.viewStore = ViewStore(store.scope(state: ViewState.init, action: ViewAction.to(orderPlacedAction:)))
  }

  public var body: some View {
    VStack(spacing: 0) {
      Text("Order Status Card")

      if viewStore.isGuest {
        signUpBanner
      }

    }.frame(maxWidth: .infinity, maxHeight: .infinity)
      .background {
        ZStack {
          Text("Smoothie Image")
          if !viewStore.orderIsReady {
            Rectangle()
              .fill(.ultraThinMaterial)
          }
        }
      }
  }

  var signUpBanner: some View {
    VStack {
      Text("Sign up to get rewards!")

      Text("SignInWithAppleButton")
        .frame(minWidth: 100, maxWidth: 400)
    }
    .frame(maxWidth: .infinity)
    .padding()
  }
}

extension OrderPlacedView.ViewState {
  init(state: OrderPlacedState) {
    self.isGuest = state.account.isGuest
    self.orderIsReady = state.order.isReady
  }
}

extension OrderPlacedView.ViewAction {
  static func to(orderPlacedAction action: Self) -> OrderPlacedAction {
    switch action {
    case let .authenticate(request):
      return .account(.authenticate(request))
    }
  }
}
