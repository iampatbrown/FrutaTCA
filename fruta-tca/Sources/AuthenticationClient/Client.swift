import ComposableArchitecture
import Foundation

public enum AuthenticationRequest: Equatable {
  case appleId(String?)
}

public struct AuthenticationError: Equatable, Error {}

public struct AuthenticationClient {
  public var authenticate: (AuthenticationRequest) -> Effect<Bool, AuthenticationError>
  public var currentUser: () -> String?
  public var refreshAuthentication: () -> Effect<Bool, AuthenticationError>

  public init(
    authenticate: @escaping (AuthenticationRequest) -> Effect<Bool, AuthenticationError>,
    currentUser: @escaping () -> String?,
    refreshAuthentication: @escaping () -> Effect<Bool, AuthenticationError>
  ) {
    self.authenticate = authenticate
    self.currentUser = currentUser
    self.refreshAuthentication = refreshAuthentication
  }
}
