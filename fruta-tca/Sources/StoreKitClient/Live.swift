import Combine
import ComposableArchitecture
import Foundation
import StoreKit

extension StoreKitClient {
  public static let live = Self(
    fetchProducts: { identifiers in
      .task { @MainActor in try await Product.products(for: identifiers) }
    },
    listenForUpdates: {
      .run { subscriber in
        let listener = Task { @MainActor in
          for await update in Transaction.updates {
            subscriber.send(update)
          }
        }
        return AnyCancellable {
          listener.cancel()
        }
      }
    },
    purchase: { product in
      Effect.task { try await product.purchase() }
    }
  )
}
