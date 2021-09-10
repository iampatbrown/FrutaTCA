import Combine
import SwiftUI

private struct AssignEnvironment<Value>: ViewModifier where Value: Equatable {
  @Environment(\.self) var environment
  let toValue: (EnvironmentValues) -> Value
  @Binding var value: Value

  func body(content: Content) -> some View {
    let current = toValue(environment)
    return content
      .onAppear { if value != current { value = current } }
      .onChange(of: current) { if value != $0 { value = $0 } }
  }
}

extension View {
  public func assignEnvironment<Value>(
    _ toValue: @escaping (EnvironmentValues) -> Value,
    to value: Binding<Value>
  ) -> some View where Value: Equatable {
    self.modifier(AssignEnvironment(toValue: toValue, value: value))
  }
}
