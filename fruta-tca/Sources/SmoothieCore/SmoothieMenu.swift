import ComposableArchitecture
import SwiftUI

public typealias MenuState = SmoothieListState

public typealias MenuAction = SmoothieListAction

public let menuReducer: Reducer<MenuState, MenuAction, Void> = smoothieListReducer

public struct SmoothieMenu: View {
  public let store: Store<SmoothieListState, SmoothieListAction>

  public init(store: Store<SmoothieListState, SmoothieListAction>) {
    self.store = store
  }

  public var body: some View {
    SmoothieList(store: self.store)
      .navigationTitle(Text("Menu"))
  }
}
