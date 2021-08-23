/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 A button to favorite a smoothie, can be placed in a toolbar.
 */

import SwiftUI

public struct SmoothieFavoriteButton: View {
  @Binding var isFavorite: Bool

  public init(isFavorite: Binding<Bool>) {
    self._isFavorite = isFavorite
  }

  public var body: some View {
    Button(action: { isFavorite.toggle() }) {
      if isFavorite {
        Label {
          Text(
            "Remove from Favorites",
            comment: "Toolbar button/menu item to remove a smoothie from favorites"
          )
        } icon: {
          Image(systemName: "heart.fill")
        }
      } else {
        Label {
          Text("Add to Favorites", comment: "Toolbar button/menu item to add a smoothie to favorites")
        } icon: {
          Image(systemName: "heart")
        }
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
