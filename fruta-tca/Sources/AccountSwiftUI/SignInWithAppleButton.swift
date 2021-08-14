import AuthenticationClient
import AuthenticationServices
import SwiftUI

// TODO: Maybe pull this out into AuthenticationSwiftUI or make own for better control in simulator ???
extension SignInWithAppleButton {
  public init(
    _ label: SignInWithAppleButton.Label,
    onCompletion authenticate: @escaping (AuthenticationRequest) -> Void
  ) {
    self.init(
      onRequest: { _ in },
      onCompletion: { result in
        let credential = try? result.get().credential as? ASAuthorizationAppleIDCredential
        authenticate(.appleId(credential?.user))
      }
    )
  }
}
