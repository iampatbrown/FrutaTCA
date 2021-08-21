import AppFeature
import AuthenticationClient
import ComposableArchitecture
import NutritionFactFileClient
import StoreKitClient
import SwiftUI

struct RootView: View {
  let store = Store(
    initialState: AppState(),
    reducer: appReducer,
    environment: AppEnvironment(
      authenticationClient: .live,
      mainQueue: .main,
      nutritionFacts: .file(),
      storeKit: .live
    )
  )

  var body: some View {
    AppView(store: store)
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
