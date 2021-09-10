import SwiftUI

public struct SmoothieFavoriteButton: View {
  @Binding var isFavorite: Bool

  public init(isFavorite: Binding<Bool>) {
    self._isFavorite = isFavorite
  }

  public var body: some View {
    Button(action: { isFavorite.toggle() }) {
      if isFavorite {
        Label { Text("Remove from Favorites") } icon: { Image(systemName: "heart.fill") }
      } else {
        Label { Text("Add to Favorites") } icon: { Image(systemName: "heart") }
      }
    }
  }
}

struct SmoothieFavoriteButton_Previews: PreviewProvider {
  static var previews: some View {
    SmoothieFavoriteButton(isFavorite: .constant(true))
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
