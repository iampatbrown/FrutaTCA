import AuthenticationClient
import AuthenticationServices
import ComposableArchitecture
import SharedModels
import SharedUI
import StoreKit
import SwiftUI

public struct OrderPlacedState: Equatable {
  public var account: Account?
  public var order: Order?

  public init(
    account: Account?,
    order: Order?
  ) {
    self.account = account
    self.order = order
  }

  var orderIsReady: Bool { order?.isReady ?? false }
  var hasAccount: Bool { account != nil } // TODO: Must also be authorized with appleId
  var presentingBottomBanner: Bool { !hasAccount }
}

public enum OrderPlacedAction: Equatable {
  case orderReadyForPickup
  case authenticate(AuthenticationRequest)
  case authenticationResponse(Result<Bool, AuthenticationError>)
}

public struct OrderPlacedEnvironment {
  public var authentication: AuthenticationClient

  public init(authentication: AuthenticationClient) {
    self.authentication = authentication
  }
}

public let orderPlacedReducer = Reducer<
  OrderPlacedState,
  OrderPlacedAction,
  OrderPlacedEnvironment
> { state, action, environment in
  switch action {
  case .orderReadyForPickup:
    state.order?.isReady = true
    return .none

  case let .authenticate(request):
    return environment
      .authentication
      .authenticate(request)
      .catchToEffect(OrderPlacedAction.authenticationResponse)

  case .authenticationResponse(.success(true)):
    if state.account == nil { state.account = Account() }
    return .none

  case .authenticationResponse:
    // TODO: Handle other responses
    return .none
  }
}

public struct OrderPlacedView: View {
  let store: Store<OrderPlacedState, OrderPlacedAction>
  @ObservedObject var viewStore: ViewStore<OrderPlacedState, OrderPlacedAction>

  public init(store: Store<OrderPlacedState, OrderPlacedAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

//    #if APPCLIP
//    @State private var presentingAppStoreOverlay = false
//    #endif

//    var presentingBottomBanner: Bool {
//        #if APPCLIP
//        if presentingAppStoreOverlay { return true }
//        #endif
//        return !viewStore.hasAccount
//    }

  /// - Tag: ActiveCompilationConditionTag
  public var body: some View {
    VStack(spacing: 0) {
      Spacer()

      orderStatusCard

      Spacer()

      if viewStore.presentingBottomBanner {
        bottomBanner
      }

//            #if APPCLIP
//            Text(verbatim: "App Store Overlay")
//                .hidden()
//                .appStoreOverlay(isPresented: $presentingAppStoreOverlay) {
//                    SKOverlay.AppClipConfiguration(position: .bottom)
//                }
//            #endif
    }
//        .onChange(of: model.hasAccount) { _ in
//            #if APPCLIP
//            if model.hasAccount {
//                presentingAppStoreOverlay = true
//            }
//            #endif
//        }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      ZStack {
        if let order = viewStore.order {
          order.smoothie.image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } else {
          Color.orderPlacedBackground
        }

        if viewStore.order?.isReady == false {
          Rectangle()
            .fill(.ultraThinMaterial)
        }
      }
      .ignoresSafeArea()
    }
    .animation(.spring(response: 0.25, dampingFraction: 1), value: viewStore.orderIsReady)
    .animation(.spring(response: 0.25, dampingFraction: 1), value: viewStore.hasAccount)
    .onAppear {
      DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
        viewStore.send(.orderReadyForPickup)
      }
//      #if APPCLIP
//        if model.hasAccount {
//          presentingAppStoreOverlay = true
//        }
//      #endif
    }
  }

  var orderStatusCard: some View {
    FlipView(visibleSide: viewStore.orderIsReady ? .back : .front) {
      Card(
        title: "Thank you for your order!",
        subtitle: "We will notify you when your order is ready."
      )
    } back: {
      let smoothieName = viewStore.order?.smoothie.title ?? String(
        localized: "Smoothie",
        comment: "Fallback name for smoothie"
      )
      Card(
        title: "Your smoothie is ready!",
        subtitle: "\(smoothieName) is ready to be picked up."
      )
    }
    .animation(.flipCard, value: viewStore.orderIsReady)
    .padding()
  }

  var bottomBanner: some View {
    VStack {
      if !viewStore.hasAccount {
        Text("Sign up to get rewards!")
          .font(Font.headline.bold())

        SignInWithAppleButton(.signUp) {
          viewStore.send(.authenticate($0), animation: .default)
        }
        .frame(minWidth: 100, maxWidth: 400)
        .padding(.horizontal, 20)
        #if os(iOS)
          .frame(height: 45)
        #endif
      } else {
//        #if APPCLIP
//          if presentingAppStoreOverlay {
//            Text("Get the full smoothie experience!")
//              .font(Font.title2.bold())
//              .padding(.top, 15)
//              .padding(.bottom, 150)
//          }
//        #endif
      }
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(.bar)
  }

  struct Card: View {
    var title: LocalizedStringKey
    var subtitle: LocalizedStringKey

    var body: some View {
      VStack(spacing: 16) {
        Text(title)
          .font(Font.title.bold())
          .textCase(.uppercase)
          .layoutPriority(1)
        Text(subtitle)
          .font(.system(.headline, design: .rounded))
          .foregroundStyle(.secondary)
      }
      .multilineTextAlignment(.center)
      .padding(.horizontal, 36)
      .frame(width: 300, height: 300)
      .background(in: Circle())
    }
  }
}

// struct OrderPlacedView_Previews: PreviewProvider {
//    static let orderReady: Model = {
//        let model = Model()
//        model.orderSmoothie(Smoothie.berryBlue)
//        model.orderReadyForPickup()
//        return model
//    }()
//    static let orderNotReady: Model = {
//        let model = Model()
//        model.orderSmoothie(Smoothie.berryBlue)
//        return model
//    }()
//    static var previews: some View {
//        Group {
//            #if !APPCLIP
//            OrderPlacedView()
//                .environmentObject(orderNotReady)
//
//            OrderPlacedView()
//                .environmentObject(orderReady)
//            #endif
//        }
//    }
// }
