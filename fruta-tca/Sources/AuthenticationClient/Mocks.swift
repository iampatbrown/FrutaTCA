import Foundation

extension AuthenticationClient {
  static var currentUser: String?

  public static let mock = Self(
    authenticate: { _ in
      .future { callback in
        currentUser = "mock"
        callback(.success(true))
      }
    }, currentUser: { currentUser },
    refreshAuthentication: {
      .future { callback in
        callback(.success(currentUser != nil))
      }
    }
  )
}
