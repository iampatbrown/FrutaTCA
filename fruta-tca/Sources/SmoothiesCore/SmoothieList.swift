import AuthenticationClient
import ComposableArchitecture
import SharedModels
import SwiftUI

public struct SmoothieListState: Equatable {
  public var account: Account?
  public var order: Order?
  public var searchString: String
  public var favoriteSmoothieIDs: Set<Smoothie.ID>
  public var filterFavorites: Bool

  public init(
    account: Account? = nil,
    order: Order? = nil,
    selection: SmoothieState? = nil,
    searchString: String = "",
    favoriteSmoothieIDs: Set<Smoothie.ID> = [],
    filterFavorites: Bool = false
  ) {
    self.account = account
    self.order = order
    self._selection = selection
    self.searchString = searchString
    self.favoriteSmoothieIDs = favoriteSmoothieIDs
    self.filterFavorites = filterFavorites
  }

  public var _selection: SmoothieState?
  public var selection: SmoothieState? { // TODO: WHAT ARE YOU DOING?!?
    get {
      guard var selection = _selection else { return nil }
      selection.isFavorite = self.isFavorite(selection.id)
      selection.account = self.account
      selection.order = self.order
      return selection
    }
    set {
      if let selection = newValue {
        self._selection = selection
        self.account = selection.account
        self.order = selection.order
        if selection.isFavorite != isFavorite(selection.id) {
          self.toggleFavorite(selection.id)
        }
      } else {
        self._selection = nil
      }
    }
  }

  public var listedSmoothies: [Smoothie] {
    Smoothie.all() // TODO: ARRRRRR!!!!!
      .filter { $0.matches(searchString) }
      .filter { filterFavorites ? favoriteSmoothieIDs.contains($0.id) : true }
      .sorted(by: { $0.title.localizedCompare($1.title) == .orderedAscending })
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

public enum SmoothieListAction: Equatable {
  case searchStringChanged(String)
  case toggleFavorite(Smoothie)
  case setSelection(Smoothie.ID?)
  case smoothie(SmoothieAction)
}

public struct SmoothieListEnvironment {
  public var authentication: AuthenticationClient

  public init(authentication: AuthenticationClient) {
    self.authentication = authentication
  }
}

public let smoothiesReducer = Reducer<
  SmoothieListState,
  SmoothieListAction,
  SmoothieListEnvironment
>.combine(
  smoothieReducer
    .optional()
    .pullback(
      state: \.selection,
      action: /SmoothieListAction.smoothie,
      environment: { .init(authentication: $0.authentication) }
    ),
  Reducer { state, action, environment in
    switch action {
    case let .searchStringChanged(searchString):
      state.searchString = searchString
      return .none

    case let .toggleFavorite(smoothie):
      state.toggleFavorite(smoothie.id)
      return .none

    case let .setSelection(.some(id)):
      guard id != state.selection?.id,
            let smoothie = Smoothie(for: id) else { return .none } // TODO: Also... ARRR!!!!!
      state._selection = .init(account: state.account, order: state.order, smoothie: smoothie)
      return .none

    case .setSelection(nil):
      state._selection = nil
      return .none

    case .smoothie:
      return .none
    }
  }
)

public struct SmoothieList: View {
  let store: Store<SmoothieListState, SmoothieListAction>

  public init(store: Store<SmoothieListState, SmoothieListAction>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      List {
        ForEach(viewStore.listedSmoothies) { smoothie in
          NavigationLink(
            tag: smoothie.id,
            selection: viewStore.binding(
              get: \.selection?.smoothie.id,
              send: SmoothieListAction.setSelection
            )
          ) {
            IfLetStore(
              self.store.scope(
                state: { $0.selection.flatMap { smoothie.id == $0.id ? $0 : nil } },
                action: SmoothieListAction.smoothie
              ),
              then: SmoothieView.init
            ) {}
          } label: {
            SmoothieRow(smoothie: smoothie)
          }
          .swipeActions {
            Button {
              viewStore.send(.toggleFavorite(smoothie), animation: .default)
            } label: {
              Label {
                Text("Favorite", comment: "Swipe action button in smoothie list")
              } icon: {
                Image(systemName: "heart")
              }
            }
            .tint(.appAccentColor)
          }
        }
      }.searchable(
        text: viewStore.binding(
          get: \.searchString,
          send: SmoothieListAction.searchStringChanged
        )
      ) {
        ForEach(viewStore.searchSuggestions) { suggestion in
          Text(suggestion.name)
            .searchCompletion(suggestion.name)
        }
      }
    }
  }
}
