import ComposableArchitecture
import OrderCore
import OrderSwiftUI
import SwiftUI

@main
struct OrderPreviewApp: App {
  var body: some Scene {
    WindowGroup {
      OrderPlacedView(
        store: Store(
          initialState: OrderState(smoothie: .berryBlue),
          reducer: orderReducer,
          environment: OrderEnvironment()
        )
      )
    }
  }
}
