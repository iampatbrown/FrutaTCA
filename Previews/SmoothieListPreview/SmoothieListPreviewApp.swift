import ComposableArchitecture
import NutritionFactFileClient
import SmoothiesCore
import SmoothiesSwiftUI
import SwiftUI

@main
struct SmoothieListPreviewApp: App {
  let store = Store(
    initialState: SmoothiesState(),
    reducer: smoothiesReducer,
    environment: SmoothiesEnvironment(nutritionFacts: .file())
  )

  enum Tab {
    case menu
    case favorites
    case rewards
    case recipes
  }

  @State private var selection: Tab = .menu

  var body: some Scene {
    WindowGroup {
      TabView(selection: $selection) {
        NavigationView {
          SmoothieMenu(store: store)
        }.tabItem {
          let menuText = Text("Menu", comment: "Smoothie menu tab title")
          Label {
            menuText
          } icon: {
            Image(systemName: "list.bullet")
          }.accessibility(label: menuText)
        }
        .tag(Tab.menu)

        NavigationView {
          FavoriteSmoothies(store: store)
        }
        .tabItem {
          Label {
            Text(
              "Favorites",
              comment: "Favorite smoothies tab title"
            )
          } icon: {
            Image(systemName: "heart.fill")
          }
        }
        .tag(Tab.favorites)
      }
    }
  }
}
