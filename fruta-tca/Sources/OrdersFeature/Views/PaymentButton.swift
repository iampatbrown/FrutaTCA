import PassKit
import SwiftUI

public struct PaymentButton: View {
  var action: () -> Void

  public init(action: @escaping () -> Void) {
    self.action = action
  }

  var height: Double {
    #if os(macOS)
      return 30
    #else
      return 45
    #endif
  }

  public var body: some View {
    Representable(action: action)
      .frame(minWidth: 100, maxWidth: 400)
      .frame(height: height)
      .frame(maxWidth: .infinity)
      .accessibility(label: Text(
        "Buy with Apple Pay",
        comment: "Accessibility label for Buy with Apple Pay button"
      ))
  }
}

extension PaymentButton {
  #if os(iOS)
    typealias ViewRepresentable = UIViewRepresentable
  #else
    typealias ViewRepresentable = NSViewRepresentable
  #endif

  struct Representable: ViewRepresentable {
    var action: () -> Void

    func makeCoordinator() -> Coordinator {
      Coordinator(action: action)
    }

    #if os(iOS)
      func makeUIView(context: Context) -> UIView {
        context.coordinator.button
      }

      func updateUIView(_ rootView: UIView, context: Context) {
        context.coordinator.action = action
      }
    #else
      func makeNSView(context: Context) -> NSView {
        context.coordinator.button
      }

      func updateNSView(_ rootView: NSView, context: Context) {
        context.coordinator.action = action
      }
    #endif
  }

  class Coordinator: NSObject {
    var action: () -> Void
    var button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .automatic)

    init(action: @escaping () -> Void) {
      self.action = action
      super.init()
      #if os(iOS)
        button.addTarget(self, action: #selector(callback(_:)), for: .touchUpInside)
      #else
        button.action = #selector(callback(_:))
        button.target = self
      #endif
    }

    @objc
    func callback(_ sender: Any) {
      action()
    }
  }
}

struct PaymentButton_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      PaymentButton(action: {})
        .padding()
        .preferredColorScheme(.light)
      PaymentButton(action: {})
        .padding()
        .preferredColorScheme(.dark)
    }
    .previewLayout(.sizeThatFits)
  }
}
