import ComposableArchitecture
import Foundation
import StoreKit

public struct StoreKitClient {
  public var fetchProducts: (Set<String>) -> Effect<[Product], Error>
  public var isVerified: (Product) -> Effect<Bool, Never>
  public var listenForUpdates: () -> Effect<VerificationResult<Transaction>, Never>
  public var purchase: (Product) -> Effect<Product.PurchaseResult, Error>

  public init(
    fetchProducts: @escaping (Set<String>) -> Effect<[Product], Error>,
    isVerified: @escaping (Product) -> Effect<Bool, Never>,
    listenForUpdates: @escaping () -> Effect<VerificationResult<Transaction>, Never>,
    purchase: @escaping (Product) -> Effect<Product.PurchaseResult, Error>
  ) {
    self.fetchProducts = fetchProducts
    self.isVerified = isVerified
    self.listenForUpdates = listenForUpdates
    self.purchase = purchase
  }
}
