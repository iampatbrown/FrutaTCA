import AppFeature
import AuthenticationClient
import ComposableArchitecture
import SwiftUI

@main
struct FrutaTCAApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: Store(
          initialState: .init(),
          reducer: appReducer,
          environment: .init(authentication: .mock, mainQueue: .main, storeKit: .live)
        )
      )
    }
  }
}
