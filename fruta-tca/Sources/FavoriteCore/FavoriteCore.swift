import ComposableArchitecture
import Foundation

public struct FavoriteState<ID>: Equatable, Identifiable where ID: Hashable {
  public let id: ID
  public var isFavorite: Bool

  public init(id: ID, isFavorite: Bool) {
    self.id = id
    self.isFavorite = isFavorite
  }
}

public enum FavoriteAction: Equatable {
  case toggleIsFavorite
}

public struct FavoriteEnvironment<ID> {
  public init() {}
}

extension Reducer {
  public func favorite<ID>(
    state: WritableKeyPath<State, FavoriteState<ID>>,
    action: CasePath<Action, FavoriteAction>,
    environment: @escaping (Environment) -> FavoriteEnvironment<ID>
  ) -> Reducer where ID: Hashable {
    .combine(
      self,
      Reducer<FavoriteState, FavoriteAction, FavoriteEnvironment> {
        state, action, environment in
        switch action {
        case .toggleIsFavorite:
          state.isFavorite.toggle()
          return .none
        }
      }
      .pullback(state: state, action: action, environment: environment)
    )
  }
}
