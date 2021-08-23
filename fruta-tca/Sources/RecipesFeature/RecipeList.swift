import ComposableArchitecture
import SharedModels
import SharedUI
import SmoothiesCore
import StoreKit
import StoreKitClient
import SwiftUI

public struct RecipeListState: Equatable {
  public var account: Account?
  public var favoriteSmoothieIDs: Set<Smoothie.ID>
  public var searchString: String
  public var selection: Smoothie.ID?
  public var store: StoreKitState

  public init(
    account: Account? = nil,
    favoriteSmoothieIDs: Set<Smoothie.ID> = [],
    searchString: String = "",
    selection: Smoothie.ID? = nil,
    store: StoreKitState = .init()

  ) {
    self.account = account
    self.favoriteSmoothieIDs = favoriteSmoothieIDs
    self.searchString = searchString
    self.selection = selection
    self.store = store
  }

  public var allRecipesUnlocked: Bool { store.allRecipesUnlocked }
  public var unlockAllRecipesProduct: Product? { store.unlockAllRecipesProduct }

  public var listedSmoothies: [Smoothie] {
    Smoothie.all(includingPaid: store.allRecipesUnlocked) // TODO: What's the plan here???
      .filter { $0.matches(searchString) }
      .sorted(by: { $0.title.localizedCompare($1.title) == .orderedAscending })
  }

  public var favoriteListedSmoothies: [Smoothie] {
    listedSmoothies.filter { isFavorite($0.id) }
  }

  public var searchSuggestions: [Ingredient] {
    Ingredient.all.filter {
      $0.name.localizedCaseInsensitiveContains(searchString) &&
        $0.name.localizedCaseInsensitiveCompare(searchString) != .orderedSame
    }
  }

  func isFavorite(_ id: Smoothie.ID) -> Bool {
    favoriteSmoothieIDs.contains(id)
  }

  mutating func toggleFavorite(_ id: Smoothie.ID) {
    if favoriteSmoothieIDs.contains(id) {
      favoriteSmoothieIDs.remove(id)
    } else {
      favoriteSmoothieIDs.insert(id)
    }
  }
}

public enum RecipeListAction: Equatable {
  case searchStringChanged(String)
  case setSelection(Smoothie.ID?)
  case setIsFavorite(Smoothie.ID, Bool)
  case store(StoreKitAction)
}

public struct RecipeListEnvironment {
  public var storeKit: StoreKitClient

  public init(storeKit: StoreKitClient) {
    self.storeKit = storeKit
  }
}

public let recipesReducer = Reducer<
  RecipeListState,
  RecipeListAction,
  RecipeListEnvironment
>.combine(
  storeKitReducer.pullback(
    state: \.store,
    action: /RecipeListAction.store,
    environment: { .init(storeKit: $0.storeKit) }
  ),
  Reducer { state, action, environment in
    switch action {
    case let .searchStringChanged(searchString):
      state.searchString = searchString
      return .none

    case let .setSelection(selection):
      state.selection = selection
      return .none

    case let .setIsFavorite(id, isFavorite):
      guard isFavorite != state.isFavorite(id) else { return .none }
      state.toggleFavorite(id)
      return .none

    case .store:
      return .none
    }
  }
)
public struct RecipeList: View {
  let store: Store<RecipeListState, RecipeListAction>

  @ObservedObject var viewStore: ViewStore<RecipeListState, RecipeListAction>

  public init(store: Store<RecipeListState, RecipeListAction>) {
    self.store = store
    self.viewStore = ViewStore(store)
  }

  public var body: some View {
    List {
      #if os(iOS)
        if !viewStore.allRecipesUnlocked {
          Section {
            unlockButton
              .listRowInsets(EdgeInsets())
              .listRowBackground(EmptyView())
              .listSectionSeparator(.hidden)
              .listRowSeparator(.hidden)
          }
          .listSectionSeparator(.hidden)
        }
      #endif
      ForEach(viewStore.listedSmoothies) { smoothie in
        NavigationLink(
          tag: smoothie.id,
          selection: viewStore.binding(
            get: \.selection,
            send: RecipeListAction.setSelection
          )
        ) {
          RecipeView(
            smoothie: smoothie,
            isFavorite: viewStore.binding(
              get: { $0.isFavorite(smoothie.id) },
              send: { RecipeListAction.setIsFavorite(smoothie.id, $0) }
            )
          )
        } label: {
          SmoothieRow(smoothie: smoothie)
            .padding(.vertical, 5)
        }
      }
    }
    #if os(iOS)
      .listStyle(.insetGrouped)
    #elseif os(macOS)
      .safeAreaInset(edge: .bottom, spacing: 0) {
        if !viewStore.allRecipesUnlocked {
          unlockButton
            .padding(8)
        }
      }
    #endif
    .navigationTitle(Text(
      "Recipes",
      comment: "Title of the 'recipes' app section showing the list of smoothie recipes."
    ))
      .animation(.spring(response: 1, dampingFraction: 1), value: viewStore.allRecipesUnlocked)
      .accessibilityRotor(
        "Favorite Smoothies",
        entries: viewStore.favoriteListedSmoothies,
        entryLabel: \.title
      )
      .accessibilityRotor("Smoothies", entries: viewStore.listedSmoothies, entryLabel: \.title)
      .searchable(
        text: viewStore.binding(
          get: \.searchString,
          send: RecipeListAction.searchStringChanged
        )
      ) {
        ForEach(viewStore.searchSuggestions) { suggestion in
          Text(suggestion.name)
            .searchCompletion(suggestion.name)
        }
      }
  }

  @ViewBuilder
  var unlockButton: some View {
    Group {
      if let product = viewStore.unlockAllRecipesProduct {
        RecipeUnlockButton(
          product: RecipeUnlockButton.Product(for: product),
          purchaseAction: { viewStore.send(.store(.purchase(product))) }
        )
      } else {
        RecipeUnlockButton(
          product: RecipeUnlockButton.Product(
            title: "Unlock All Recipes",
            description: "Loading…",
            availability: .unavailable
          ),
          purchaseAction: {}
        )
      }
    }
    .transition(.scale.combined(with: .opacity))
  }
}

// struct RecipeList_Previews: PreviewProvider {
//  static let unlocked: Model = {
//    let store = Model()
//    store.allRecipesUnlocked = true
//    return store
//  }()
//
//  static var previews: some View {
//    Group {
//      NavigationView {
//        RecipeList()
//      }
//      .environmentObject(Model())
//      .previewDisplayName("Locked")
//
//      NavigationView {
//        RecipeList()
//      }
//      .environmentObject(unlocked)
//      .previewDisplayName("Unlocked")
//    }
//  }
// }
