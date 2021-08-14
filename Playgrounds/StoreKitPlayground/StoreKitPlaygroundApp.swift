import ComposableArchitecture
import StoreKitClient
import StoreKitCore
import SwiftUI

@main
struct StoreKitPlaygroundApp: App {
  let store: Store<StoreKitState, StoreKitAction> = Store(
    initialState: StoreKitState(allProductIdentifiers: ["dev.patbrown.fruta-tca.unlock-recipes"]),
    reducer: storeKitReducer,
    environment: StoreKitEnvironment(mainQueue: .main, storeKit: .live)
  )

  var body: some Scene {
    WindowGroup {
      WithViewStore(self.store) { viewStore in
        ContentView()
          .onAppear {
            viewStore.send(.onAppear)
          }
      }
    }
  }
}

struct ContentView: View {
  var body: some View {
    Text("Hello Playground!")
  }
}
