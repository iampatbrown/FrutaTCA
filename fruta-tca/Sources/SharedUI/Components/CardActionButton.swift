/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A squishable button that has a consistent look for use on a card
 */

import SwiftUI

public struct CardActionButton: View {
  var label: LocalizedStringKey
  var systemImage: String
  var action: () -> Void

  public init(
    label: LocalizedStringKey,
    systemImage: String,
    action: @escaping () -> Void
  ) {
    self.label = label
    self.systemImage = systemImage
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Image(systemName: systemImage)
        .font(Font.title.bold())
        .imageScale(.large)
        .frame(width: 44, height: 44)
        .padding()
        .contentShape(Rectangle())
    }
    .buttonStyle(SquishableButtonStyle(fadeOnPress: false))
    .accessibility(label: Text(label))
  }
}

struct CardActionButton_Previews: PreviewProvider {
  static var previews: some View {
    CardActionButton(label: "Close", systemImage: "xmark", action: {})
      .previewLayout(.sizeThatFits)
  }
}
