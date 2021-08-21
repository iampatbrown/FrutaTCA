import SwiftUI

struct MeasurementView<Unit: Foundation.Unit>: View {
  var measurement: Measurement<Unit>

  var body: some View {
    HStack {
      Image(measurement.unit)
        .foregroundStyle(.secondary)

      Text(measurement.localizedSummary())
    }
  }
}

struct MeasurementView_Previews: PreviewProvider {
  static var previews: some View {
    MeasurementView(
      measurement: Measurement(value: 1.5, unit: UnitVolume.cups)
    )
    .padding()
    .previewLayout(.sizeThatFits)
  }
}
