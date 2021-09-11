import ComposableArchitecture

extension IdentifiedArray {
  public func sorted(
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> Self {
    var copy = self
    try copy.sort(by: areInIncreasingOrder)
    return copy
  }
}
