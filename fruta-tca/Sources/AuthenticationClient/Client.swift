import ComposableArchitecture
import Foundation

public enum AuthenticationRequest: Equatable {
  case appleId(String?)
}

public enum AuthenticationError: Equatable, LocalizedError {
  case error(String)

  public var errorDescription: String? {
    switch self {
    case let .error(description):
      return description
    }
  }
}

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
