//
//  OnboardingFlowConfiguration.swift
//  OnboardingKit
//

import SwiftUI

// MARK: - Master Configuration

public struct OnboardingFlowConfiguration {
    public let splash: SplashConfiguration
    public let pages: [PageConfiguration]
    public let iap: IAPConfiguration
    public let primaryColor: Color
    public let font: FontTheme

    public init(
        splash: SplashConfiguration,
        pages: [PageConfiguration],
        iap: IAPConfiguration,
        primaryColor: Color = .blue,
        font: FontTheme = .system
    ) {
        self.splash = splash
        self.pages = pages
        self.iap = iap
        self.primaryColor = primaryColor
        self.font = font
    }
}

// MARK: - Splash Configuration

public struct SplashConfiguration {
    public let icon: String
    public let iconCornerRadius: CGFloat
    public let title: String
    public let subtitle: String

    public init(
        icon: String,
        iconCornerRadius: CGFloat = 32,
        title: String,
        subtitle: String
    ) {
        self.icon = icon
        self.iconCornerRadius = iconCornerRadius
        self.title = title
        self.subtitle = subtitle
    }
}

// MARK: - Page Configuration

public struct PageConfiguration: Identifiable {
    public let id: Int
    public let image: UIImage?
    public let title: String
    public let subtitle: String
    public let zoomScale: CGFloat
    public let zoomAnchor: UnitPoint

    public init(
        id: Int,
        image: UIImage?,
        title: String,
        subtitle: String,
        zoomScale: CGFloat = 1.0,
        zoomAnchor: UnitPoint = .center
    ) {
        self.id = id
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.zoomScale = zoomScale
        self.zoomAnchor = zoomAnchor
    }
}

// MARK: - IAP Configuration

public struct IAPConfiguration {
    public let chipText: String
    public let heroTitle: String
    public let heroSubtitle: String
    public let features: [FeatureRow]
    public let products: [ProductOption]
    public let trialText: String
    public let ctaTitle: String
    public let ctaSubtitle: String
    public let dismissDelay: CGFloat
    public let defaultProductIndex: Int

    public init(
        chipText: String = "FREE vs PRO",
        heroTitle: String = "Why go Pro?",
        heroSubtitle: String = "See everything you unlock today.",
        features: [FeatureRow],
        products: [ProductOption],
        trialText: String = "3-day free trial \u{2022} No charge today",
        ctaTitle: String = "Try Free for 3 Days",
        ctaSubtitle: String = "Then $1.99/mo \u{2022} Cancel anytime",
        dismissDelay: CGFloat = 10,
        defaultProductIndex: Int = 0
    ) {
        self.chipText = chipText
        self.heroTitle = heroTitle
        self.heroSubtitle = heroSubtitle
        self.features = features
        self.products = products
        self.trialText = trialText
        self.ctaTitle = ctaTitle
        self.ctaSubtitle = ctaSubtitle
        self.dismissDelay = dismissDelay
        self.defaultProductIndex = defaultProductIndex
    }
}

// MARK: - IAP Feature Row

public struct FeatureRow: Identifiable {
    public let id: Int
    public let name: String
    public let freeValue: String
    public let proValue: String

    public init(id: Int, name: String, freeValue: String, proValue: String) {
        self.id = id
        self.name = name
        self.freeValue = freeValue
        self.proValue = proValue
    }
}

// MARK: - IAP Product Option

public struct ProductOption: Identifiable {
    public let id: Int
    public let title: String
    public let subtitle: String
    public let price: String
    public let secondaryPrice: String
    public let badge: String?

    public init(
        id: Int,
        title: String,
        subtitle: String,
        price: String,
        secondaryPrice: String,
        badge: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.price = price
        self.secondaryPrice = secondaryPrice
        self.badge = badge
    }
}
