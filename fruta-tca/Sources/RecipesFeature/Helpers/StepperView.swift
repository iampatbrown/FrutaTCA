import SwiftUI

// MARK: - StepperView

struct StepperView: View {
    @Binding var value: Int {
        didSet {
            tilt = value > oldValue ? 1 : -1
            withAnimation(.interactiveSpring(response: 1, dampingFraction: 1)) {
                tilt = 0
            }
        }
    }
    var label: LocalizedStringKey
    var configuration: Configuration

    @State private var tilt = 0.0

    var body: some View {
        HStack {
            CountButton(mode: .decrement, action: decrement)
                .disabled(value <= configuration.minValue)

            Text(label)
                .frame(width: 150)
                .padding(.vertical)

            CountButton(mode: .increment, action: increment)
                .disabled(configuration.maxValue <= value)
        }
        .accessibilityRepresentation {
            Stepper("Smoothie Count", value: $value,
                                in: configuration.minValue...configuration.maxValue,
                                step: configuration.increment)
        }
        .font(Font.title2.bold())
        .foregroundStyle(.primary)
        .background(.thinMaterial, in: Capsule())
        .contentShape(Capsule())
        .rotation3DEffect(.degrees(3 * tilt), axis: (x: 0, y: 1, z: 0))
    }

    func increment() {
        value = min(max(value + configuration.increment, configuration.minValue), configuration.maxValue)
    }

    func decrement() {
        value = min(max(value - configuration.increment, configuration.minValue), configuration.maxValue)
    }
}

// MARK: - StepperView.Configuration

extension StepperView {
    struct Configuration {
        var increment: Int
        var minValue: Int
        var maxValue: Int
    }
}
