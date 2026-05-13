//
//  SpacerExtensions.swift
//  OnboardingKit
//

import SwiftUI

extension Spacer {
    @ViewBuilder
    func height(_ height: CGFloat) -> some View {
        if height > 0 {
            frame(height: height)
        } else {
            self
        }
    }

    @ViewBuilder
    func width(_ width: CGFloat) -> some View {
        if width > 0 {
            frame(width: width)
        } else {
            self
        }
    }
}
