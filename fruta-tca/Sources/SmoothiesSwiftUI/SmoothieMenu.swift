import ComposableArchitecture
import SmoothiesCore
import SwiftUI

public struct SmoothieMenu: View {
  let store: Store<SmoothiesState, SmoothiesAction>

  public init(store: Store<SmoothiesState, SmoothiesAction>) {
    self.store = store
  }

  public var body: some View {
    SmoothieList(store: store)
      .navigationTitle(
        Text(
          "Menu",
          comment: "Title of the 'menu' app section showing the menu of available smoothies"
        )
      )
  }
}
