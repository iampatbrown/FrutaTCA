import ComposableArchitecture
import Foundation

extension AuthenticationClient {
  static var currentUser: String?

  public static let mock = Self(
    authenticate: { _ in
      print("jererer")
      currentUser = "mock"
      return Effect(value: true)
    },
    currentUser: { currentUser },
    refreshAuthentication: { Effect(value: currentUser != nil) }
  )
}
