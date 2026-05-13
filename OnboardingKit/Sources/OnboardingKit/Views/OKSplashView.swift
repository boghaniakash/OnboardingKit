//
//  OKSplashView.swift
//  OnboardingKit
//

import SwiftUI

struct OKSplashView: View {
    let configuration: OnboardingFlowConfiguration
    let namespace: Namespace.ID
    var onAppear: () async -> Void
    var onComplete: () -> Void

    @State private var isAnimating = false

    var body: some View {
        GlassEffectContainer {
            ZStack {
                BlurCircleBG()
                ContentSection()
            }
        }
        .task {
            withAnimation(.easeInOut(duration: 1)) {
                isAnimating = true
            }
            await onAppear()
            try? await Task.sleep(for: .seconds(2))
            onComplete()
        }
    }
}

// MARK: - Background
extension OKSplashView {
    @ViewBuilder
    private func BlurCircleBG() -> some View {
        Circle()
            .fill(configuration.primaryColor)
            .frame(width: isAnimating ? 180 : 0, height: isAnimating ? 180 : 0)
            .blur(radius: isAnimating ? 110 : 0)
            .matchedGeometryEffect(id: "Circle", in: namespace)
    }
}

// MARK: - Content
extension OKSplashView {
    @ViewBuilder
    private func ContentSection() -> some View {
        let splash = configuration.splash

        VStack(spacing: 12) {
            Image(systemName: splash.icon)
                .scaleEffect(isAnimating ? 2.5 : 0)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: isAnimating ? 100 : 0, height: isAnimating ? 100 : 0)
                .foregroundStyle(configuration.primaryColor)
                .glassEffect(.clear.interactive(), in: RoundedRectangle(cornerRadius: splash.iconCornerRadius))

            VStack(spacing: 4) {
                Text(splash.title)
                    .font(configuration.font.title1)
                    .scaleEffect(isAnimating ? 1 : 3)
                    .opacity(isAnimating ? 1 : 0)

                Text(splash.subtitle)
                    .font(configuration.font.body)
                    .foregroundStyle(.tertiary)
                    .opacity(isAnimating ? 1 : 0)
            }
        }
    }
}
