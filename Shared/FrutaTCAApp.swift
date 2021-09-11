import AppFeature
import ComposableArchitecture
import SwiftUI

@main
struct FrutaTCAApp: App {
  let store = Store(
    initialState: .mock,
    reducer: appReducer.debug(actionFormat: .labelsOnly),
    environment: AppEnvironment()
  )

  var body: some Scene {
    WindowGroup {
      AppView(store: self.store)
    }.commands {
      SidebarCommands()
    }
  }
}
