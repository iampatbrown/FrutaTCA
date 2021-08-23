public struct Account: Equatable {
  public var orderHistory = [Order]()
  public var pointsSpent = 0
  public var unstampedPoints = 0

  public init(
    orderHistory: [Order] = [Order](),
    pointsSpent: Int = 0,
    unstampedPoints: Int = 0
  ) {
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

  public var canRedeemFreeSmoothie: Bool {
    unspentPoints >= 10
  }

  public mutating func clearUnstampedPoints() {
    unstampedPoints = 0
  }

  public mutating func appendOrder(_ order: Order) {
    orderHistory.append(order)
    unstampedPoints += order.points
  }
}
