import SwiftUI

struct SmoothieHeaderView: View {
  let imageName: String
  let title: String
  let description: AttributedString
  let energy: String

  init(state: SmoothieState) { // TODO: Is it okay to do this? maybe no...
    self.imageName = state.id
    self.title = state.title
    self.description = state.description
    self.energy = state.energy.formatted(.measurement(width: .wide, usage: .food))
  }

    var body: some View {
      VStack(spacing: 0) {
        Image(imageName)
          .resizable()
          .aspectRatio(contentMode: .fill)

        VStack(alignment: .leading) {
          Text(description)
          Text(energy)
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
      }
    }
}


