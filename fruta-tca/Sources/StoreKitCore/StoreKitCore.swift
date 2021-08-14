import ComposableArchitecture
import Foundation
import StoreKit
import StoreKitClient

public struct StoreKitState: Equatable {
  public init(
    allRecipesUnlocked: Bool = false,
    unlockAllRecipesProduct: Product? = nil,
    allProductIdentifiers: Set<String> = [],
    fetchedProducts: [Product] = []
  ) {
    self.allRecipesUnlocked = allRecipesUnlocked
    self.unlockAllRecipesProduct = unlockAllRecipesProduct
    self.allProductIdentifiers = allProductIdentifiers
    self.fetchedProducts = fetchedProducts
  }

  public var allRecipesUnlocked: Bool
  public var unlockAllRecipesProduct: Product?
  public var allProductIdentifiers: Set<String>
  public var fetchedProducts: [Product] = []
}

public enum StoreKitAction: Equatable {
  case onAppear
  case fetchProductsResponse(Result<[Product], NSError>)
  case transactionUpdate(VerificationResult<Transaction>)
  case purchase(Product)
  case purchaseResponse(Result<Product.PurchaseResult, NSError>)
}

// TODO: Create wrappers for Equatable conformance
extension Product.PurchaseResult: Equatable {
  public static func == (lhs: Product.PurchaseResult, rhs: Product.PurchaseResult) -> Bool {
    switch (lhs, rhs) {
    case let (.success(lhsResult), .success(rhsResult)):
      return lhsResult == rhsResult
    case (pending, pending), (userCancelled, userCancelled):
      return true
    default:
      return false
    }
  }
}

public struct StoreKitEnvironment {
  public var mainQueue: AnySchedulerOf<DispatchQueue>
  public var storeKit: StoreKitClient

  public init(
    mainQueue: AnySchedulerOf<DispatchQueue>,
    storeKit: StoreKitClient
  ) {
    self.mainQueue = mainQueue
    self.storeKit = storeKit
  }
}

public let storeKitReducer = Reducer<StoreKitState, StoreKitAction, StoreKitEnvironment> { state, action, environment in
  switch action {
  case .onAppear:
    return .merge(
      environment.storeKit
        .listenForUpdates()
        .map(StoreKitAction.transactionUpdate),
      environment.storeKit
        .fetchProducts(state.allProductIdentifiers)
        .catchToEffect { .fetchProductsResponse($0.mapError { $0 as NSError }) }
    )

  case let .transactionUpdate(update):
    // TODO: Handle updates
    return .none

  case let .fetchProductsResponse(.success(products)):
    state.fetchedProducts = products
    let productsToCheck = products.filter { state.allProductIdentifiers.contains($0.id) }
    // TODO: Check if product is verified
    return .none

  case .fetchProductsResponse(.failure):
    // TODO: Handle errors
    return .none

  case let .purchase(product):
    return environment.storeKit
      .purchase(product)
      .receive(on: environment.mainQueue)
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
