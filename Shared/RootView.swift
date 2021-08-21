import AppFeature
import AuthenticationClient
// import ComposableArchitecture
import NutritionFactClient
import StoreKitClient
import SwiftUI

struct RootView: View {
  var body: some View {
    AppView(store: .init(
      initialState: AppState(),
      reducer: appReducer,
      environment: AppEnvironment(
        authenticationClient: .live,
        mainQueue: .main,
        nutritionFacts: .live,
        storeKit: .live
      )
    ))
  }
}

struct RootView_Previews: PreviewProvider {
  static var previews: some View {
    RootView()
  }
}
