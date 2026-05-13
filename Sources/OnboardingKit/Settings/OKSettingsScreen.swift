//
//  OKSettingsScreen.swift
//  OnboardingKit
//
//  A reusable settings screen shell with a glass nav bar overlay on a ScrollView.
//  Wrap in NavigationStack externally to handle navigation destinations.
//

import SwiftUI

public struct OKSettingsScreen<NavButtons: View, Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let navButtons: () -> NavButtons
    @ViewBuilder let content: () -> Content

    @Environment(\.okFont) private var font
    @State private var navBarSize: CGSize = .zero

    private var safeAreaTop: CGFloat {
        UIApplication.shared.okKeyWindow?.safeAreaInsets.top ?? 0
    }

    public init(
        title: String,
        subtitle: String,
        @ViewBuilder navButtons: @escaping () -> NavButtons,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.navButtons = navButtons
        self.content = content
    }

    public var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                VStack(spacing: 15) {
                    content()
                    Spacer().height(40)
                }
                .padding(15)
                .padding(.top, navBarSize.height)
            }
            .scrollIndicators(.hidden)

            TopNavBar()
        }
        .ignoresSafeArea(.all, edges: .top)
    }
}

// MARK: - Nav Bar
extension OKSettingsScreen {
    @ViewBuilder
    private func TopNavBar() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(title)
                        .font(font.largeTitle)

                    Text(subtitle)
                        .font(font.calloutMedium)
                        .foregroundStyle(Color.white.opacity(0.5))
                }

                Spacer()

                GlassEffectContainer(spacing: 8) {
                    HStack(spacing: 8) {
                        navButtons()
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.top, safeAreaTop)
        .padding(.bottom, 15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect)
        .onGeometryChange(for: CGSize.self) {
            $0.size
        } action: { newValue in
            navBarSize = newValue
        }
    }
}
