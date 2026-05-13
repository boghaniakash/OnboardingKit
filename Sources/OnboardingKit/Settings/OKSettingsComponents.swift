//
//  OKSettingsComponents.swift
//  OnboardingKit
//

import SwiftUI

// MARK: - Section

public struct OKSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    @Environment(\.okFont) private var font

    public init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title.uppercased())
                .font(font.caption1Medium)
                .tracking(1.5)
                .foregroundStyle(Color.white.opacity(0.4))
                .padding(.leading, 5)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                content()
            }
            .frame(maxWidth: .infinity)
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
        }
    }
}

// MARK: - Pro Banner

public struct OKProBanner: View {
    let icon: String
    let iconTint: Color
    let title: String
    let subtitle: String
    let buttonText: String
    let action: () -> Void

    @Environment(\.okFont) private var font
    @Environment(\.okPrimaryColor) private var primaryColor

    public init(
        icon: String = "crown.fill",
        iconTint: Color = Color(.systemYellow),
        title: String = "Upgrade to Pro",
        subtitle: String = "Unlock all features & remove ads",
        buttonText: String = "GO",
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self.subtitle = subtitle
        self.buttonText = buttonText
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(iconTint)
                .frame(width: 50, height: 50)
                .glassEffect(.regular.tint(iconTint.opacity(0.15)), in: .rect(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(font.headline)
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(font.footnote)
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            Spacer()

            Button {
                action()
            } label: {
                Text(buttonText)
                    .font(font.ctaSecondary)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
            }
            .glassEffect(.regular.tint(primaryColor.opacity(0.3)).interactive(), in: .capsule)
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular.tint(primaryColor.opacity(0.05)), in: .rect(cornerRadius: 24))
    }
}

// MARK: - App Info Footer

public struct OKAppInfoFooter: View {
    let appName: String
    let version: String

    @Environment(\.okFont) private var font

    public init(appName: String, version: String) {
        self.appName = appName
        self.version = version
    }

    public var body: some View {
        VStack(spacing: 4) {
            Text(appName)
                .font(font.footnoteMedium)
                .foregroundStyle(Color.white.opacity(0.3))

            Text("Version \(version)")
                .font(font.caption2)
                .foregroundStyle(Color.white.opacity(0.2))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 10)
    }
}
