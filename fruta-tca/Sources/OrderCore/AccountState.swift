import Foundation


public struct AccountState: Equatable {
  public var orderHistory: [OrderState]
  public var pointsSpent: Int
  public var unstampedPoints: Int
}
