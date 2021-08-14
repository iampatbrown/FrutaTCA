import ComposableArchitecture
import Foundation
import SmoothieCore

public struct OrderState: Equatable {
  public var smoothie: Smoothie
  public var points: Int
  public var isReady: Bool

  public init(
    smoothie: Smoothie,
    points: Int = 1,
    isReady: Bool = false
  ) {
    self.smoothie = smoothie
    self.points = points
    self.isReady = isReady
  }

  public var hasAccount: Bool { false } // TODO: Implement AccountCore
}

public struct OrderError: Equatable, Error, Identifiable {
  public let error: NSError
  public var localizedDescription: String { self.error.localizedDescription }
  public var id: String { self.error.localizedDescription }
  public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}

public enum OrderAction: Equatable {
  case order(Smoothie)
  case account // AccountCore not yet implemented
  case response(Result<Bool, OrderError>)
}

public struct OrderEnvironment {
  public var orderClient: String

  public init() {
    self.orderClient = "OrderClient not yet implemented"
  }
}

public let orderReducer = Reducer<OrderState, OrderAction, OrderEnvironment> { state, action, environment in
  switch action {
  case .order:
    return .none

  case .account:
    return .none
  case let .response(.success(result)):
    state.isReady = result
    return .none

  case .response(.failure):
    return .none
  }
}
