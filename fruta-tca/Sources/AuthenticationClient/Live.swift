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
        .future { callback in

          switch request {
          case let .appleId(.some(user)):
            currentUser = user
            callback(.success(true))
          case .appleId(.none):
            callback(.success(false))
          }
        }
      }, currentUser: { currentUser },
      refreshAuthentication: {
        .future { callback in
          guard let user = currentUser else { return callback(.success(false)) }

          let appleIDProvider = ASAuthorizationAppleIDProvider()

          appleIDProvider.getCredentialState(forUserID: user) { state, error in
            if let error = error {
              return callback(.failure(.error(error.localizedDescription)))
            }

            switch state {
            case .authorized, .transferred:
              callback(.success(true))
            default:
              callback(.success(false))
            }
          }
        }
      }
    )
  }
}
