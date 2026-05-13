//
//  FontTheme.swift
//  OnboardingKit
//

import SwiftUI

public struct FontTheme: Sendable {
    public let regular: String?
    public let medium: String?
    public let bold: String?
    public let black: String?

    public static let system = FontTheme(regular: nil, medium: nil, bold: nil, black: nil)

    public init(regular: String?, medium: String?, bold: String?, black: String?) {
        self.regular = regular
        self.medium = medium
        self.bold = bold
        self.black = black
    }

    // MARK: - Font Builder

    enum Weight {
        case regular, medium, bold, black
    }

    func font(size: CGFloat, weight: Weight, relativeTo style: Font.TextStyle) -> Font {
        let name: String? = switch weight {
        case .regular: regular
        case .medium: medium
        case .bold: bold
        case .black: black
        }

        if let name {
            return .custom(name, size: size, relativeTo: style)
        }

        let systemWeight: Font.Weight = switch weight {
        case .regular: .regular
        case .medium: .medium
        case .bold: .bold
        case .black: .black
        }

        return .system(size: size, weight: systemWeight)
    }

    // MARK: - Display

    public var displayXL: Font { font(size: 42, weight: .black, relativeTo: .largeTitle) }
    public var displayLG: Font { font(size: 34, weight: .black, relativeTo: .largeTitle) }
    public var displayMD: Font { font(size: 28, weight: .black, relativeTo: .title) }

    // MARK: - Title

    public var largeTitle: Font { font(size: 30, weight: .bold, relativeTo: .largeTitle) }
    public var title1: Font { font(size: 26, weight: .bold, relativeTo: .title) }
    public var title2: Font { font(size: 22, weight: .bold, relativeTo: .title2) }
    public var title3: Font { font(size: 20, weight: .medium, relativeTo: .title3) }

    // MARK: - Body

    public var headline: Font { font(size: 17, weight: .bold, relativeTo: .headline) }
    public var body: Font { font(size: 17, weight: .regular, relativeTo: .body) }
    public var bodyMedium: Font { font(size: 17, weight: .medium, relativeTo: .body) }
    public var callout: Font { font(size: 16, weight: .regular, relativeTo: .callout) }
    public var calloutMedium: Font { font(size: 16, weight: .medium, relativeTo: .callout) }

    // MARK: - Small

    public var subheadline: Font { font(size: 15, weight: .regular, relativeTo: .subheadline) }
    public var subheadlineMedium: Font { font(size: 15, weight: .medium, relativeTo: .subheadline) }
    public var footnote: Font { font(size: 13, weight: .regular, relativeTo: .footnote) }
    public var footnoteMedium: Font { font(size: 13, weight: .medium, relativeTo: .footnote) }
    public var caption1: Font { font(size: 12, weight: .regular, relativeTo: .caption) }
    public var caption1Medium: Font { font(size: 12, weight: .medium, relativeTo: .caption) }
    public var caption2: Font { font(size: 11, weight: .regular, relativeTo: .caption2) }
    public var caption2Medium: Font { font(size: 11, weight: .medium, relativeTo: .caption2) }

    // MARK: - CTA

    public var ctaPrimary: Font { font(size: 17, weight: .bold, relativeTo: .headline) }
    public var ctaSecondary: Font { font(size: 15, weight: .medium, relativeTo: .subheadline) }
}
