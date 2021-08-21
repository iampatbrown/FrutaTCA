import AuthenticationServices
import ComposableArchitecture
import SharedSwiftUI
import SmoothieCore
import SwiftUI

public struct OrderPlacedView: View {
  let store: Store<OrderState, OrderAction>
  @ObservedObject var viewStore: ViewStore<OrderState, OrderAction>

  public init(store: Store<OrderState, OrderAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  var presentingBottomBanner: Bool { !viewStore.hasAccount }

  public var body: some View {
    VStack(spacing: 0) {
      Spacer()

      orderStatusCard

      Spacer()

      if presentingBottomBanner {
        bottomBanner
      }
    }

    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background {
      ZStack {
        Image(viewStore.smoothie)
          .resizable()
          .aspectRatio(contentMode: .fill)

        if !viewStore.isReady {
          Rectangle()
            .fill(.ultraThinMaterial)
        }
      }.onTapGesture {
        viewStore.send(.response(.success(!viewStore.isReady)))
      }
      .ignoresSafeArea()
    }
    .animation(.spring(response: 0.25, dampingFraction: 1), value: viewStore.isReady)
    .animation(.spring(response: 0.25, dampingFraction: 1), value: viewStore.hasAccount)
  }

  var orderStatusCard: some View {
    FlipView(visibleSide: viewStore.isReady ? .back : .front) {
      Card(
        title: "Thank you for your order!",
        subtitle: "We will notify you when your order is ready."
      )
    } back: {
      let smoothieName = viewStore.smoothie.title
      Card(
        title: "Your smoothie is ready!",
        subtitle: "\(smoothieName) is ready to be picked up."
      )
    }
    .animation(.flipCard, value: viewStore.isReady)
    .padding()
  }

  var bottomBanner: some View {
    VStack {
      if !viewStore.hasAccount {
        Text("Sign up to get rewards!")
          .font(Font.headline.bold())

        // TODO: MOCK THIS
        SignInWithAppleButton(.signUp, onRequest: { _ in }, onCompletion: { _ in viewStore.send(.account) })
          .frame(minWidth: 100, maxWidth: 400)
          .padding(.horizontal, 20)
        #if os(iOS)
          .frame(height: 45)
        #endif
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
