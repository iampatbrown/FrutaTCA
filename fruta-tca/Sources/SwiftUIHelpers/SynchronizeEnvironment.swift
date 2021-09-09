import Combine
import SwiftUI

private struct SynchronizeEnvironment<Value>: ViewModifier {
  @Environment(\.self) var environment
  @Binding var value: Value
  let isDuplicate: (Value, Value) -> Bool
  let toValue: (EnvironmentValues) -> Value

  var current: Value { toValue(environment) }

  func body(content: Content) -> some View {
    let current = EquatableBox(value: toValue(environment), isDuplicate: isDuplicate)
    return content.onAppear {
      if !current.valueIsEqual(to: value) { value = current.value }
    }.onChange(of: current) { value = $0.value }
  }

  private struct EquatableBox<Value>: Equatable {
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
  public func syncronize<Value>(
    _ value: Binding<Value>,
    removeDuplicates isDuplicate: @escaping (Value, Value) -> Bool,
    _ toValue: @escaping (EnvironmentValues) -> Value
  ) -> some View {
    self.modifier(SynchronizeEnvironment(value: value, isDuplicate: isDuplicate, toValue: toValue))
  }

  public func syncronize<Value>(
    _ value: Binding<Value>,
    _ toValue: @escaping (EnvironmentValues) -> Value
  ) -> some View where Value: Equatable {
    self.syncronize(value, removeDuplicates: ==, toValue)
  }
}
