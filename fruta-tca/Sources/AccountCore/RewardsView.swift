import AccountCore
import AuthenticationServices
import ComposableArchitecture
import SharedSwiftUI
import SwiftUI

public struct RewardsView: View {
  let store: Store<AccountState?, AccountAction>
  @ObservedObject var viewStore: ViewStore<AccountState?, AccountAction>

  public init(store: Store<AccountState?, AccountAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  public var body: some View {
    ZStack {
      RewardsCard(
        totalStamps: viewStore.unspentPoints,
        animatedStamps: viewStore.unstampedPoints,
        hasAccount: viewStore.hasAccount
      ).onDisappear {
        viewStore.send(.clearUnstampedPoints)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    #if os(iOS)
      .navigationBarTitleDisplayMode(.inline)
    #endif
    .safeAreaInset(edge: .bottom, spacing: 0) {
      VStack(spacing: 0) {
        Divider()
        if !viewStore.hasAccount {
          SignInWithAppleButton(.signIn, onCompletion: { viewStore.send(.authenticate($0), animation: .default) })
            .frame(minWidth: 100, maxWidth: 400)
            .padding(.horizontal, 20)
          #if os(iOS)
            .frame(height: 45)
          #endif
          .padding(.horizontal, 20)
            .padding()
            .frame(maxWidth: .infinity)
        }
      }
      .background(.bar)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(BubbleBackground().ignoresSafeArea())
  }
}

// Temp helper for optional state
extension ViewStore where State == AccountState?, Action == AccountAction {
  var hasAccount: Bool { state != nil }
  var unspentPoints: Int { state?.unspentPoints ?? 0 }
  var unstampedPoints: Int { state?.unstampedPoints ?? 0 }
}
