//
//  PaywallView.swift
//  OnboardingKit
//
//  A standalone IAP paywall screen for use outside the onboarding flow
//  (e.g., from Settings or a "Go Pro" button).
//

import SwiftUI

public struct PaywallView: View {
    private let configuration: OnboardingFlowConfiguration
    private let onComplete: () -> Void
    private let onPurchase: (Int) -> Void
    private let onRestore: () -> Void
    private let onTermsTapped: () -> Void
    private let onPrivacyTapped: () -> Void

    @Namespace private var namespace

    public init(
        configuration: OnboardingFlowConfiguration,
        onComplete: @escaping () -> Void,
        onPurchase: @escaping (Int) -> Void = { _ in },
        onRestore: @escaping () -> Void = {},
        onTermsTapped: @escaping () -> Void = {},
        onPrivacyTapped: @escaping () -> Void = {}
    ) {
        self.configuration = configuration
        self.onComplete = onComplete
        self.onPurchase = onPurchase
        self.onRestore = onRestore
        self.onTermsTapped = onTermsTapped
        self.onPrivacyTapped = onPrivacyTapped
    }

    public var body: some View {
        OKIAPView(
            configuration: configuration,
            namespace: namespace,
            isFromOnboarding: false,
            onComplete: onComplete,
            onPurchase: onPurchase,
            onRestore: onRestore,
            onTermsTapped: onTermsTapped,
            onPrivacyTapped: onPrivacyTapped
        )
    }
}
