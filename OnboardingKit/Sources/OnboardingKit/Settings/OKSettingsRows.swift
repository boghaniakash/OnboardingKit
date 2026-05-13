//
//  OKSettingsRows.swift
//  OnboardingKit
//

import SwiftUI

// MARK: - Plain Row

public struct OKRow: View {
    let icon: String
    let iconTint: Color
    let title: String
    let subtitle: String?

    @Environment(\.okFont) private var font

    public init(
        icon: String,
        iconTint: Color = .white,
        title: String,
        subtitle: String? = nil
    ) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self.subtitle = subtitle
    }

    public var body: some View {
        HStack(spacing: 12) {
            IconView(icon: icon, tint: iconTint)

            Text(title)
                .font(font.bodyMedium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let subtitle {
                Text(subtitle)
                    .font(font.footnote)
                    .foregroundStyle(Color.white.opacity(0.4))
            }

            Image(systemName: "chevron.right")
                .font(.footnote)
                .foregroundStyle(Color.white.opacity(0.3))
        }
        .padding(.horizontal, 15)
        .frame(height: 56)
    }
}

// MARK: - Navigation Row

public struct OKNavigationRow: View {
    let icon: String
    let iconTint: Color
    let title: String
    let subtitle: String?
    let action: () -> Void

    @Environment(\.okFont) private var font

    public init(
        icon: String,
        iconTint: Color = .white,
        title: String,
        subtitle: String? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self.subtitle = subtitle
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                IconView(icon: icon, tint: iconTint)

                Text(title)
                    .font(font.bodyMedium)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let subtitle {
                    Text(subtitle)
                        .font(font.footnote)
                        .foregroundStyle(Color.white.opacity(0.4))
                }

                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundStyle(Color.white.opacity(0.3))
            }
            .padding(.horizontal, 15)
            .frame(height: 56)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Toggle Row

public struct OKToggleRow: View {
    let icon: String
    let iconTint: Color
    let title: String
    @Binding var isOn: Bool

    @Environment(\.okFont) private var font
    @Environment(\.okPrimaryColor) private var primaryColor

    public init(
        icon: String,
        iconTint: Color = .white,
        title: String,
        isOn: Binding<Bool>
    ) {
        self.icon = icon
        self.iconTint = iconTint
        self.title = title
        self._isOn = isOn
    }

    public var body: some View {
        HStack(spacing: 12) {
            IconView(icon: icon, tint: iconTint)

            Text(title)
                .font(font.bodyMedium)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(primaryColor)
        }
        .padding(.horizontal, 15)
        .frame(height: 56)
    }
}

// MARK: - Shared Icon View

struct IconView: View {
    let icon: String
    let tint: Color

    var body: some View {
        Image(systemName: icon)
            .font(.body)
            .foregroundStyle(tint)
            .frame(width: 34, height: 34)
            .glassEffect(.regular.tint(tint.opacity(0.1)), in: .rect(cornerRadius: 8))
    }
}
