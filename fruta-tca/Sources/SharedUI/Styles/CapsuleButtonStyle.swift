/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A button style that displays over a capsule background.
*/

import SwiftUI
import SharedModels

public struct CapsuleButtonStyle: ButtonStyle {
  public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .dynamicTypeSize(.large)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(in: Capsule())
            .foregroundStyle(Color.appAccentColor)
            .contentShape(Capsule())
            #if os(iOS)
            .hoverEffect(.lift)
            #endif
    }
}

extension ButtonStyle where Self == CapsuleButtonStyle {
  public static var capsule: CapsuleButtonStyle {
        CapsuleButtonStyle()
    }
}
