import ComposableArchitecture
import SwiftUI

public struct SmoothieMenu: View {
  public let store: Store<SmoothieListState, SmoothieListAction>

  public init(store: Store<SmoothieListState, SmoothieListAction>) {
    self.store = store
  }

  public var body: some View {
    SmoothieList(store: self.store)
      .navigationTitle(Text(
        "Menu",
        comment: "Title of the 'menu' app section showing the menu of available smoothies"
      ))
  }
}
