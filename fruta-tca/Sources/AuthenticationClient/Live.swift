import AuthenticationServices
import ComposableArchitecture
import Foundation

extension AuthenticationClient {
  private static let currentUserKey = "dev.patbrown.fruta-tca.currentUser"

  public static var live: Self {
    var currentUser = UserDefaults.standard.string(forKey: currentUserKey) {
      didSet {
        UserDefaults.standard.set(currentUser, forKey: currentUserKey)
      }
    }

    return Self(
      authenticate: { request in
        if case let .appleId(.some(userID)) = request {
          currentUser = userID
          return Effect(value: true)
        } else {
          return Effect(value: false)
        }
      },
      currentUser: { currentUser },
      refreshAuthentication: {
        guard let userID = currentUser else { return Effect(value: false) }
        return Effect.task {
          let appleIDProvider = ASAuthorizationAppleIDProvider()
          let state = try await appleIDProvider.credentialState(forUserID: userID)
          return state == .authorized || state == .transferred
        }.mapError { _ in return AuthenticationError() }
          .eraseToEffect()
      }
    )
  }
}
