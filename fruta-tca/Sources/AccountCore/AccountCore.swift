import AuthenticationClient
import ComposableArchitecture
import Foundation
import OrderCore

public struct AccountState: Equatable {
  public var orderHistory: [OrderState]
  public var pointsSpent: Int
  public var unstampedPoints: Int

  public init(
    orderHistory: [OrderState] = [],
    pointsSpent: Int = 0,
    unstampedPoints: Int = 0
  ) {
    self.orderHistory = orderHistory
    self.pointsSpent = pointsSpent
    self.unstampedPoints = unstampedPoints
  }

  public var canRedeemFreeSmoothie: Bool { unspentPoints >= 10 }
  public var pointsEarned: Int { orderHistory.reduce(0) { $0 + $1.points } }
  public var unspentPoints: Int { pointsEarned - pointsSpent }
}

public enum AccountAction: Equatable {
  case appendOrder(OrderState)
  case authenticate(AuthenticationRequest)
  case authenticationResponse(Result<Bool, AuthenticationError>)
  case clearUnstampedPoints
  case refreshAuthentication
}

public struct AccountEnvironment {
  public var authenticationClient: AuthenticationClient

  public init(
    authenticationClient: AuthenticationClient
  ) {
    self.authenticationClient = authenticationClient
  }
}

public let accountReducer = Reducer<AccountState?, AccountAction, AccountEnvironment> { state, action, environment in
  switch action {
  case let .appendOrder(order):
    state?.orderHistory.append(order)
    return .none

  case let .authenticate(request):
    return environment.authenticationClient
      .authenticate(request)
      .catchToEffect(AccountAction.authenticationResponse)

  case .authenticationResponse(.success(true)):
    if state == nil { state = AccountState() }
    return .none

  case .authenticationResponse(.success(false)):
    // TODO: Handle false
    state = nil
    return .none

  case .authenticationResponse(.failure):
    // TODO: Handle errors
    return .none

  case .clearUnstampedPoints:
    state?.unstampedPoints = 0
    return .none

  case .refreshAuthentication:
    return environment.authenticationClient
      .refreshAuthentication()
      .catchToEffect(AccountAction.authenticationResponse)
  }
}
