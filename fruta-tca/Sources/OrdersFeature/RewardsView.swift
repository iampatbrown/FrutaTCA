import AuthenticationClient
import AuthenticationServices
import ComposableArchitecture
import SharedModels
import SharedUI
import SwiftUI

public struct RewardsState: Equatable {
  public var account: Account?

  public init(account: Account? = nil) {
    self.account = account
  }

  public var totalStamps: Int { account?.unspentPoints ?? 0 }
  public var animatedStamps: Int { account?.unstampedPoints ?? 0 }
  public var hasAccount: Bool { account != nil }
}

public enum RewardsAction: Equatable {
  case clearUnstampedPoints
  case authenticate(AuthenticationRequest)
  case authenticationResponse(Result<Bool, AuthenticationError>)
}

public struct RewardsEnvironment {
  public var authentication: AuthenticationClient

  public init(authentication: AuthenticationClient) {
    self.authentication = authentication
  }
}

public let rewardsReducer = Reducer<RewardsState, RewardsAction, RewardsEnvironment> { state, action, environment in
  switch action {
  case .clearUnstampedPoints:
    state.account?.clearUnstampedPoints()
    return .none

  case let .authenticate(request):
    return environment
      .authentication
      .authenticate(request)
      .catchToEffect(RewardsAction.authenticationResponse)

  case .authenticationResponse(.success(true)):
    if state.account == nil { state.account = Account() }
    return .none

  case .authenticationResponse:
    // TODO: Handle other responses
    return .none
  }
}

public struct RewardsView: View {
  let store: Store<RewardsState, RewardsAction>

  public init(store: Store<RewardsState, RewardsAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        RewardsCard(
          totalStamps: viewStore.totalStamps,
          animatedStamps: viewStore.animatedStamps,
          hasAccount: viewStore.hasAccount
        )
        .onDisappear {
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
            SignInWithAppleButton(.signUp) {
              viewStore.send(.authenticate($0), animation: .default)
            }
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
}
