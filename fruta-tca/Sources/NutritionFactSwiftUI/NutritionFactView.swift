import NutritionFactCore
import SwiftUI

public struct NutritionFactView: View {
  public init(nutritionFact: NutritionFact) {
    self.nutritionFact = nutritionFact.converted(toVolume: .cups(1))
  }

  public var nutritionFact: NutritionFact

  public var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      VStack(alignment: .leading) {
        Text("Nutrition Facts")
          .font(.title2)
          .bold()
        Text("Serving Size 1 Cup")
          .font(.footnote)
        Text(nutritionFact.energy.formatted(.measurement(width: .wide, usage: .food)))
          .fontWeight(.semibold)
          .padding(.top, 10)
      }
      .padding(20)

      Divider()
        .padding(.horizontal, 20)

      ScrollView {
        VStack(spacing: 0) {
          ForEach(nutritionFact.nutritions) { nutrition in
            NutritionRow(nutrition: nutrition)
              .padding(.vertical, 4)
              .padding(.leading, nutrition.indented ? 10 : 0)
            Divider()
          }
        }
        .padding([.bottom, .horizontal], 20)
      }
    }
  }
}
