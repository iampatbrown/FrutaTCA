/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Reusable animations for certain aspects of the app like opening, closing, and flipping cards.
*/

import SwiftUI

extension Animation {
    public static let openCard = Animation.spring(response: 0.45, dampingFraction: 0.9)
    public static let closeCard = Animation.spring(response: 0.35, dampingFraction: 1)
    public static let flipCard = Animation.spring(response: 0.35, dampingFraction: 0.7)
}
