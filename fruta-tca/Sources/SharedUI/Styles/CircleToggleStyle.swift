/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A toggle style that uses system checkmark images to represent the On state.
*/

import SwiftUI
import SharedModels

public struct CircleToggleStyle: ToggleStyle {
  public func makeBody(configuration: Configuration) -> some View {
        ZStack {
            configuration.label.hidden()
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .accessibility(label: configuration.isOn ?
                               Text("Checked", comment: "Accessibility label for circular style toggle that is checked (on)") :
                                Text("Unchecked", comment: "Accessibility label for circular style toggle that is unchecked (off)"))
                .foregroundStyle(configuration.isOn ? Color.appAccentColor : .secondary)
                .imageScale(.large)
                .font(Font.title)
        }
    }
}

extension ToggleStyle where Self == CircleToggleStyle {
  public static var circle: CircleToggleStyle {
        CircleToggleStyle()
    }
}
