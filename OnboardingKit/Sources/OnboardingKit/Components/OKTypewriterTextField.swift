//
//  OKTypewriterTextField.swift
//  OnboardingKit
//
//  A search bar with a typewriter-animated placeholder that cycles
//  through a list of strings, typing and erasing character by character.
//

import SwiftUI

public struct OKTypewriterTextField<TrailingContent: View>: View {
    @Binding var text: String
    let placeholders: [String]
    let prefix: String
    let icon: String
    let typingSpeed: Duration
    let erasingSpeed: Duration
    let pauseDuration: Duration
    let trailingContent: TrailingContent

    @Environment(\.okFont) private var font
    @State private var displayedPlaceholder = ""

    public init(
        text: Binding<String>,
        placeholders: [String],
        prefix: String = "",
        icon: String = "magnifyingglass",
        typingSpeed: Duration = .milliseconds(50),
        erasingSpeed: Duration = .milliseconds(30),
        pauseDuration: Duration = .seconds(2.5),
        @ViewBuilder trailingContent: () -> TrailingContent
    ) {
        self._text = text
        self.placeholders = placeholders
        self.prefix = prefix
        self.icon = icon
        self.typingSpeed = typingSpeed
        self.erasingSpeed = erasingSpeed
        self.pauseDuration = pauseDuration
        self.trailingContent = trailingContent()
    }

    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    HStack(spacing: 0) {
                        if !prefix.isEmpty {
                            Text(prefix)
                        }
                        Text(displayedPlaceholder)
                    }
                    .font(font.bodyMedium)
                    .foregroundStyle(Color.white)
                    .lineLimit(1)
                    .allowsHitTesting(false)
                }

                TextField("", text: $text)
                    .font(font.bodyMedium)
                    .foregroundStyle(.white)
                    .autocorrectionDisabled()
            }

            trailingContent
        }
        .padding(.horizontal, 15)
        .frame(height: 50)
        .glassEffect(.regular.interactive(), in: .capsule)
        .task {
            await startTypewriterAnimation()
        }
    }
}

// MARK: - Default (no trailing content)

extension OKTypewriterTextField where TrailingContent == EmptyView {
    public init(
        text: Binding<String>,
        placeholders: [String],
        prefix: String = "",
        icon: String = "magnifyingglass",
        typingSpeed: Duration = .milliseconds(50),
        erasingSpeed: Duration = .milliseconds(30),
        pauseDuration: Duration = .seconds(2.5)
    ) {
        self._text = text
        self.placeholders = placeholders
        self.prefix = prefix
        self.icon = icon
        self.typingSpeed = typingSpeed
        self.erasingSpeed = erasingSpeed
        self.pauseDuration = pauseDuration
        self.trailingContent = EmptyView()
    }
}

// MARK: - Typewriter Animation

extension OKTypewriterTextField {
    private func startTypewriterAnimation() async {
        guard !placeholders.isEmpty else { return }

        await typeWrite(placeholders[0])

        var index = 1
        while !Task.isCancelled {
            try? await Task.sleep(for: pauseDuration)
            guard !Task.isCancelled else { return }

            await typeErase()

            let nextText = placeholders[index % placeholders.count]
            await typeWrite(nextText)
            index += 1
        }
    }

    private func typeWrite(_ target: String) async {
        displayedPlaceholder = ""
        for char in target {
            guard !Task.isCancelled else { return }
            try? await Task.sleep(for: typingSpeed)
            displayedPlaceholder.append(char)
        }
    }

    private func typeErase() async {
        while !displayedPlaceholder.isEmpty {
            guard !Task.isCancelled else { return }
            try? await Task.sleep(for: erasingSpeed)
            _ = displayedPlaceholder.removeLast()
        }
    }
}
