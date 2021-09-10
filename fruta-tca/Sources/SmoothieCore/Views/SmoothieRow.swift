import SwiftUI

struct SmoothieRow: View {
  let imageName: String
  let title: String
  let listedIngredients: String
  let energy: String

  init(state: SmoothieState) { // TODO: Is it okay to do this? maybe no...
    self.imageName = state.id
    self.title = state.title
    self.listedIngredients = state.listedIngredients
    self.energy = state.energy.formatted(.measurement(width: .wide, usage: .food))
  }

  var body: some View {
    HStack(alignment: .top) {
      Image(imageName)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 60, height: 60)

      VStack(alignment: .leading) {
        Text(title)
          .font(.headline)

        Text(listedIngredients)
          .lineLimit(2)

        Text(energy)
          .foregroundStyle(.secondary)
          .lineLimit(1)
      }
      Spacer(minLength: 0)
    }
    .font(.subheadline)
  }
}

extension SmoothieState {
  var listedIngredients: String {
    menuIngredients.map(\.ingredient.name).joined(separator: ",")
  }
}
