import Combine
import SwiftUI

private struct EnvironmentPullback<Value>: ViewModifier {
  @Environment(\.self) var environment
  @Binding var value: Value
  let isDuplicate: (Value, Value) -> Bool
  let toValue: (EnvironmentValues) -> Value

  var current: Value { toValue(environment) }

  func body(content: Content) -> some View {
    let current = CurrentValue(value: toValue(environment), isDuplicate: isDuplicate)
    return content.onAppear {
      if !current.valueIsEqual(to: value) { value = current.value }
    }.onChange(of: current) { value = $0.value }
  }

  private struct CurrentValue<Value>: Equatable {
    let value: Value
    let isDuplicate: (Value, Value) -> Bool

    func valueIsEqual(to other: Value) -> Bool {
      isDuplicate(value, other)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.valueIsEqual(to: rhs.value)
    }
  }
}

extension View {
  public func environmentPullback<Value>(
    to value: Binding<Value>,
    removeDuplicates isDuplicate: @escaping (Value, Value) -> Bool,
    values toValue: @escaping (EnvironmentValues) -> Value
  ) -> some View {
    self.modifier(EnvironmentPullback(value: value, isDuplicate: isDuplicate, toValue: toValue))
  }

  public func environmentPullback<Value>(
    to value: Binding<Value>,
    values toValue: @escaping (EnvironmentValues) -> Value
  ) -> some View where Value: Equatable {
    self.environmentPullback(to: value, removeDuplicates: ==, values: toValue)
  }
}
