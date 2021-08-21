import ComposableArchitecture
import SwiftUI
import SmoothieCore


public typealias MenuFeatureState = SmoothiesState
public typealias MenuFeatureAction = SmoothiesAction
public typealias MenuFeatureEnvironment = SmoothiesEnvironment
public let menuFeatureReducer = smoothiesReducer



public struct MenuFeatureView: View {
  let store: Store<MenuFeatureState, MenuFeatureAction>

  public init(store: Store<MenuFeatureState, MenuFeatureAction>) {
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
