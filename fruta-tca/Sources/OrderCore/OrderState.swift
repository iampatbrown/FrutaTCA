import SharedModels

public struct OrderState: Equatable, Identifiable {
  public let id: UUID
  public var smoothie: Smoothie
  public var points: Int
  public var status: Status


  public enum Status: Equatable {
    case pending
    case ready
  }
}
