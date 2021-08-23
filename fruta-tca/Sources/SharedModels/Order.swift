public struct Order: Equatable {
  public private(set) var smoothie: Smoothie
  public private(set) var points: Int
  public var isReady: Bool

  public init(
    smoothie: Smoothie,
    points: Int,
    isReady: Bool
  ) {
    self.smoothie = smoothie
    self.points = points
    self.isReady = isReady
  }
}
