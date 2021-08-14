import AccountCore
import AccountSwiftUI
import AuthenticationAppleIDClient
import AuthenticationClient
import SwiftUI

import ComposableArchitecture

@main
struct RewardsPreviewApp: App {
  let store: Store<AccountState?, AccountAction> = Store(
    initialState: nil,
    reducer: accountReducer.debug(),
    environment: AccountEnvironment(authenticationClient: .mock)
  )

  var body: some Scene {
    WindowGroup {
      NavigationView {
        RewardsView(store: store)
      }
    }
  }
}
