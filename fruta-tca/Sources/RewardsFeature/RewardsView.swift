import AccountCore
import ComposableArchitecture
import SwiftUI

public struct RewardsState: Equatable {
  public var account: AccountState

  public init(account: AccountState) {
    self.account = account
  }

  public var totalStamps: Int { account.user?.unspentPoints ?? 0 }
  public var animatedStamps: Int { account.user?.unstampedPoints ?? 0 }
  public var isGuest: Bool { account.isGuest }
}

public enum RewardsAction: Equatable {
  case account(AccountAction)
  case clearUnstampedPoints
}

public struct RewardsView: View {
  let store: Store<RewardsState, RewardsAction>

  public init(store: Store<RewardsState, RewardsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        Text("""
        Rewards Card
        totalStamps: \(viewStore.totalStamps)
        animatedStamps: \(viewStore.animatedStamps)
        isGuest: \(viewStore.isGuest ? "Yes" : "No")
        """)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .safeAreaInset(edge: .bottom, spacing: 0) {
        VStack(spacing: 0) {
          Divider()
          if viewStore.isGuest {
            Text("SignInWithAppleButton")
              .frame(minWidth: 100, maxWidth: 400)
          }
        }
        .onDisappear {
          viewStore.send(.clearUnstampedPoints)
        }
      }
    }
  }
}
