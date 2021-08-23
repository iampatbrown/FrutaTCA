import Combine
import ComposableArchitecture
import Foundation
import StoreKit

extension StoreKitClient {
  public static let mock = Self(
    fetchProducts: { identifiers in
      fatalError()

    },
    isVerified: { _ in
      Effect(value: true)
    },
    listenForUpdates: {
      fatalError()
    },
    purchase: { _ in
      fatalError()
    }
  )
}
