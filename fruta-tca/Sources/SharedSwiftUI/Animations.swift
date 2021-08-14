import SwiftUI

extension Animation {
  public static let openCard = Animation.spring(response: 0.45, dampingFraction: 0.9)
  public static let closeCard = Animation.spring(response: 0.35, dampingFraction: 1)
  public static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
}
