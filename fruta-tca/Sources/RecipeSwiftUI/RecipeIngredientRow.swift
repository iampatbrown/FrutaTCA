import IngredientCore
import IngredientSwiftUI
import SwiftUI

struct RecipeIngredientRow: View {
  var measuredIngredient: MeasuredIngredient

  @State private var checked = false

  var style: IngredientGraphic.Style { .init(measuredIngredient.ingredient) }

  var body: some View {
    Button(action: { checked.toggle() }) {
      HStack {
        Image(measuredIngredient.ingredient)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .scaleEffect(style.thumbnailCrop.scale * 1.25)
          .frame(width: 60, height: 60)
          .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

        VStack(alignment: .leading, spacing: 4) {
          Text(measuredIngredient.ingredient.name).font(.headline)
          MeasurementView(measurement: measuredIngredient.measurement)
        }

        Spacer()

        Toggle(isOn: $checked) {
          Text(
            "Complete",
            comment: "Label for toggle showing whether you have completed adding an ingredient that's part of a smoothie recipe"
          )
        }
      }
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .toggleStyle(.circle)
  }
}
