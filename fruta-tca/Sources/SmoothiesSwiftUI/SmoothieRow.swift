import SmoothieCore
import SmoothieSwiftUI
import SwiftUI

public struct SmoothieRow: View {
  let smoothie: Smoothie

  public init(smoothie: Smoothie) {
    self.smoothie = smoothie
  }

  public var body: some View {
    HStack(alignment: .top) {
      let imageClipShape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
      Image(smoothie)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 60, height: 60)
        .clipShape(imageClipShape)
        .overlay(imageClipShape.strokeBorder(.quaternary, lineWidth: 0.5))
        .accessibility(hidden: true)

      VStack(alignment: .leading) {
        Text(smoothie.title)
          .font(.headline)

        Text(listedIngredients)
          .lineLimit(2)
          .accessibility(label: Text(
            "Ingredients: \(listedIngredients).",
            comment: "Accessibility label containing the full list of smoothie ingredients"
          ))

        Text(smoothie.energy.formatted(.measurement(width: .wide, usage: .food)))
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }

      Spacer(minLength: 0)
    }
    .font(.subheadline)
    .accessibilityElement(children: .combine)
  }

  var listedIngredients: String {
    guard !smoothie.menuIngredients.isEmpty else { return "" }
    var list = [String]()
    list.append(smoothie.menuIngredients.first!.ingredient.name.localizedCapitalized)
    list += smoothie.menuIngredients.dropFirst().map(\.ingredient.name.localizedLowercase)
    return ListFormatter.localizedString(byJoining: list)
  }

  var cornerRadius: Double {
    #if os(iOS)
      return 10
    #else
      return 4
    #endif
  }
}
