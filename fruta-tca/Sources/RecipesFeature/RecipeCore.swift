import Foundation

import ComposableArchitecture
import SmoothieCore

public struct RecipeState: Equatable, Identifiable {
  public var smoothie: Smoothie
  public var smoothieCount: Int

  public init(smoothie: Smoothie) {
    self.smoothie = smoothie
    self.smoothieCount = 1
  }

  public var id: Smoothie.ID { smoothie.id }
}

public enum RecipeAction: Equatable {
  case smoothieCountChanged(Int)
}

public struct RecipeEnvironment {
  public init() {}
}

public let recipeReducer = Reducer<RecipeState, RecipeAction, RecipeEnvironment> { state, action, environment in
  switch action {
  case let .smoothieCountChanged(smoothieCount):
    state.smoothieCount = smoothieCount
    return .none
  }
}
