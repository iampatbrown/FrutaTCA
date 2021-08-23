/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A high contrast button style for initiating purchases.
*/

import SwiftUI

public struct PurchaseButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    
    var foregroundColor: Color {
        colorScheme == .dark ? .black : .white
    }
    
    var backgroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var minWidth: Double {
        #if os(iOS)
        return 80
        #else
        return 60
        #endif
    }
    
  public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.bold())
            .foregroundStyle(foregroundColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(minWidth: minWidth)
            .background(backgroundColor, in: Capsule())
            .contentShape(Capsule())
    }
}

extension ButtonStyle where Self == PurchaseButtonStyle {
  public static var purchase: PurchaseButtonStyle {
        PurchaseButtonStyle()
    }
}
