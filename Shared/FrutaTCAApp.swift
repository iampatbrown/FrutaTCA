import AppFeature
import SwiftUI

@main
struct FrutaTCAApp: App {
  var body: some Scene {
    WindowGroup {
      AppView(
        store: .init(
          initialState: .init(),
          reducer: appReducer.debug(),
          environment: .init()
        )
      )
    }
  }
}
