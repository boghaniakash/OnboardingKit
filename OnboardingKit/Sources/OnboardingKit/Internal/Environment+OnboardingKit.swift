//
//  Environment+OnboardingKit.swift
//  OnboardingKit
//

import SwiftUI

// MARK: - Environment Keys

extension EnvironmentValues {
    @Entry public var okFont: FontTheme = .system
    @Entry public var okPrimaryColor: Color = .blue
}

// MARK: - View Modifiers

extension View {
    public func okStyle(font: FontTheme, primaryColor: Color) -> some View {
        self
            .environment(\.okFont, font)
            .environment(\.okPrimaryColor, primaryColor)
    }

    public func okStyle(from configuration: OnboardingFlowConfiguration) -> some View {
        okStyle(font: configuration.font, primaryColor: configuration.primaryColor)
    }
}

// MARK: - Safe Area Helper

extension UIApplication {
    var okKeyWindow: UIWindow? {
        connectedScenes.lazy
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
}
