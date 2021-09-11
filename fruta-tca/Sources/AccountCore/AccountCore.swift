import ComposableArchitecture
import Foundation
import SharedModels

public struct OrderState: Equatable, Identifiable {
  public let id: UUID
  public var smoothieId: Smoothie.ID
  public var smoothieTitle: String
  public var points: Int
  public var status: Status

  public enum Status: Equatable {
    case pending
    case ready
  }

  public init(
    id: UUID,
    smoothieId: Smoothie.ID,
    smoothieTitle: String,
    points: Int,
    status: OrderState.Status
  ) {
    self.id = id
    self.smoothieId = smoothieId
    self.smoothieTitle = smoothieTitle
    self.points = points
    self.status = status
  }

  public var isReady: Bool { status == .ready }
}

public enum AccountState: Equatable {
  case guest(Guest = Guest())
  case user(User)

  public struct Guest: Equatable {

    public var orderHistory: IdentifiedArrayOf<OrderState>

    public init(
      orderHistory: IdentifiedArrayOf<OrderState> = []
     ) {
      self.orderHistory = orderHistory
    }

  }

  public struct User: Equatable {

    public var appleId: String
    public var orderHistory: IdentifiedArrayOf<OrderState>
    public var pointsSpent: Int
    public var unstampedPoints: Int

    public init(
      appleId: String,
      orderHistory: IdentifiedArrayOf<OrderState> = [],
      pointsSpent: Int = 0,
      unstampedPoints: Int = 0
    ) {
      self.appleId = appleId
      self.orderHistory = orderHistory
      self.pointsSpent = pointsSpent
      self.unstampedPoints = unstampedPoints
    }

    public var pointsEarned: Int {
      orderHistory.reduce(0) { $0 + $1.points }
    }


    public var unspentPoints: Int {
      pointsEarned - pointsSpent
    }

  }

  public var isGuest: Bool {
    if case .guest = self { return true } else { return false }
  }

  public var user: User? {
    switch self {
    case let .user(user): return user
    default: return nil
    }
  }
}

public enum AccountAction: Equatable {
  case authenticate(String)
  case authenticationResponse(Bool)
}

public struct AccountEnvironment {}

let accountReducer = Reducer<AccountState, AccountAction, AccountEnvironment> { state, action, environment in
  switch action {
  case .authenticate:
    return .none
  case .authenticationResponse:
    return .none
  }
}
