import ComposableArchitecture

// TODO: Should I not do this because it conflicts with `.sorted() -> [Element]`
extension IdentifiedArray {
  public func sorted(
    by areInIncreasingOrder: (Element, Element) throws -> Bool
  ) rethrows -> Self {
    var copy = self
    try copy.sort(by: areInIncreasingOrder)
    return copy
  }
}
