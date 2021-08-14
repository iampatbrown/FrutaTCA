import SwiftUI

public struct BubbleView: View {
  public init(size: Double = 30, xOffset: Double = 0, yOffset: Double = 0, opacity: Double = 0.1) {
    self.size = size
    self.xOffset = xOffset
    self.yOffset = yOffset
    self.opacity = opacity
  }

  var size: Double = 30
  var xOffset: Double = 0
  var yOffset: Double = 0
  var opacity: Double = 0.1

  @State private var shimmer: Bool = .random()
  @State private var shimmerDelay: Double = .random(in: 0.15 ... 0.55)

  @State private var float: Bool = .random()
  @State private var floatDelay: Double = .random(in: 0.15 ... 0.55)

  public var body: some View {
    Circle()
      .blendMode(.overlay)
      .opacity(shimmer ? opacity * 2 : opacity)
      .frame(width: size, height: size)
      .scaleEffect(shimmer ? 1.1 : 1)
      .offset(x: xOffset, y: yOffset)
      .offset(y: float ? 4 : 0)
      .onAppear {
        #if !os(macOS)
          DispatchQueue.main.async {
            withAnimation(Animation.easeInOut(duration: 4 - shimmerDelay).repeatForever().delay(shimmerDelay)) {
              shimmer.toggle()
            }
            withAnimation(Animation.easeInOut(duration: 8 - floatDelay).repeatForever().delay(floatDelay)) {
              float.toggle()
            }
          }

        #endif
      }
  }
}

struct BubbleView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      ZStack {
        BubbleView(opacity: 0.9)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .foregroundStyle(.red)

      ZStack {
        BubbleView(opacity: 0.9)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
      .foregroundStyle(.blue)

      ZStack {
        BubbleView(size: 300, yOffset: -150)
        BubbleView(size: 260, xOffset: 40, yOffset: -60)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)

      BubbleView(size: 100, xOffset: -40, yOffset: 50)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}
