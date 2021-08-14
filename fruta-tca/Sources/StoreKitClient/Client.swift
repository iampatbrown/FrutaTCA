import ComposableArchitecture
import Foundation
import StoreKit

public struct StoreKitClient {
  public var fetchProducts: (Set<String>) -> Effect<[Product], Error>
  public var listenForUpdates: () -> Effect<VerificationResult<Transaction>, Never>
  public var purchase: (Product) -> Effect<Product.PurchaseResult, Error>

  public init(
    fetchProducts: @escaping (Set<String>) -> Effect<[Product], Error>,
    listenForUpdates: @escaping () -> Effect<VerificationResult<Transaction>, Never>,
    purchase: @escaping (Product) -> Effect<Product.PurchaseResult, Error>
  ) {
    self.fetchProducts = fetchProducts
    self.listenForUpdates = listenForUpdates
    self.purchase = purchase
  }
}
