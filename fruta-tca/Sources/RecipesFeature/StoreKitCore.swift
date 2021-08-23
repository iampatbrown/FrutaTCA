import ComposableArchitecture
import Foundation
import StoreKit
import StoreKitClient

public struct StoreKitState: Equatable {
  public var allRecipesUnlocked: Bool
  public var unlockAllRecipesIdentifier: String
  public var unlockAllRecipesProduct: Product?

  public init(
    allRecipesUnlocked: Bool = false,
    unlockAllRecipesIdentifier: String = "dev.patbrown.fruta-tca.unlock-recipes",
    unlockAllRecipesProduct: Product? = nil
  ) {
    self.allRecipesUnlocked = allRecipesUnlocked
    self.unlockAllRecipesIdentifier = unlockAllRecipesIdentifier
    self.unlockAllRecipesProduct = unlockAllRecipesProduct
  }
}

public enum StoreKitAction: Equatable {
  case onLaunch
  case fetchProductsResponse(Result<[Product], NSError>)
  case transactionUpdate(VerificationResult<Transaction>)
  case purchase(Product)
  case purchaseResponse(Result<Product.PurchaseResult, NSError>)
}

// TODO: Create wrappers for Equatable conformance
extension Product.PurchaseResult: Equatable {
  public static func == (lhs: Product.PurchaseResult, rhs: Product.PurchaseResult) -> Bool {
    switch (lhs, rhs) {
    case let (.success(lhsResult), .success(rhsResult)): return lhsResult == rhsResult
    case (pending, pending), (userCancelled, userCancelled): return true
    default: return false
    }
  }
}

public struct StoreKitEnvironment {
  public var storeKit: StoreKitClient

  public init(storeKit: StoreKitClient) {
    self.storeKit = storeKit
  }
}

public let storeKitReducer = Reducer<StoreKitState, StoreKitAction, StoreKitEnvironment> { state, action, environment in
  switch action {
  case .onLaunch:
    return .merge(
      environment.storeKit
        .listenForUpdates()
        .map(StoreKitAction.transactionUpdate),
      environment.storeKit
        .fetchProducts([state.unlockAllRecipesIdentifier])
        .catchToEffect { .fetchProductsResponse($0.mapError { $0 as NSError }) }
    )

  case let .transactionUpdate(update):
    // TODO: Handle updates
    return .none

  case let .fetchProductsResponse(.success(products)):
    state.unlockAllRecipesProduct = products.first(where: { $0.id == state.unlockAllRecipesIdentifier })

    return .none

  case .fetchProductsResponse(.failure):
    // TODO: Handle errors
    return .none

  case let .purchase(product):
    return environment.storeKit
      .purchase(product)
      .catchToEffect { .purchaseResponse($0.mapError { $0 as NSError }) }

  case let .purchaseResponse(.success(response)):
    if case .success = response {
      state.allRecipesUnlocked = true
    }
    return .none

  case .purchaseResponse(.failure):
    // TODO: Handle errors
    return .none
  }
}
