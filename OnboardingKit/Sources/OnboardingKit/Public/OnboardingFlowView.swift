//
//  OnboardingFlowView.swift
//  OnboardingKit
//
//  The main entry point for the full onboarding flow:
//  Splash -> Onboarding Pages -> In-App Purchase
//

import SwiftUI

public struct OnboardingFlowView: View {
    private let configuration: OnboardingFlowConfiguration
    private let onSplashAppear: () async -> Void
    private let onComplete: () -> Void
    private let onPurchase: (Int) -> Void
    private let onRestore: () -> Void
    private let onTermsTapped: () -> Void
    private let onPrivacyTapped: () -> Void

    @State private var phase: FlowPhase = .splash
    @Namespace private var namespace

    public init(
        configuration: OnboardingFlowConfiguration,
        onSplashAppear: @escaping () async -> Void = {},
        onComplete: @escaping () -> Void,
        onPurchase: @escaping (Int) -> Void = { _ in },
        onRestore: @escaping () -> Void = {},
        onTermsTapped: @escaping () -> Void = {},
        onPrivacyTapped: @escaping () -> Void = {}
    ) {
        self.configuration = configuration
        self.onSplashAppear = onSplashAppear
        self.onComplete = onComplete
        self.onPurchase = onPurchase
        self.onRestore = onRestore
        self.onTermsTapped = onTermsTapped
        self.onPrivacyTapped = onPrivacyTapped
    }

    public var body: some View {
        if phase == .splash {
            OKSplashView(
                configuration: configuration,
                namespace: namespace,
                onAppear: onSplashAppear
            ) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    phase = .onboarding
                }
            }
        } else if phase == .onboarding {
            OKOnboardingView(
                configuration: configuration,
                namespace: namespace
            ) {
                withAnimation(.smooth(duration: 0.8)) {
                    phase = .iap
                }
            }
        } else {
            OKIAPView(
                configuration: configuration,
                namespace: namespace,
                isFromOnboarding: true,
                onComplete: onComplete,
                onPurchase: onPurchase,
                onRestore: onRestore,
                onTermsTapped: onTermsTapped,
                onPrivacyTapped: onPrivacyTapped
            )
        }
    }

    private enum FlowPhase {
        case splash, onboarding, iap
    }
}
