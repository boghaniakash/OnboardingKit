//
//  OKIAPView.swift
//  OnboardingKit
//

import SwiftUI

struct OKIAPView: View {
    let configuration: OnboardingFlowConfiguration
    let namespace: Namespace.ID
    let isFromOnboarding: Bool
    var onComplete: () -> Void
    var onPurchase: (Int) -> Void
    var onRestore: () -> Void
    var onTermsTapped: () -> Void
    var onPrivacyTapped: () -> Void

    private var iap: IAPConfiguration { configuration.iap }
    private var font: FontTheme { configuration.font }
    private var primaryColor: Color { configuration.primaryColor }

    @State private var bottomViewHeight: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var currentIndex: Int = 0

    var body: some View {
        ZStack(alignment: .topTrailing) {
            BlurCircleBG()
            ZStack(alignment: .bottom) {
                BodyView()
                DismissButton()
                BottomView()
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear { currentIndex = iap.defaultProductIndex }
        .task {
            while progress <= iap.dismissDelay {
                try? await Task.sleep(for: .milliseconds(500))
                withAnimation {
                    progress += 0.7
                }
            }
        }
    }
}

// MARK: - Background
extension OKIAPView {
    @ViewBuilder
    private func BlurCircleBG() -> some View {
        Circle()
            .fill(primaryColor)
            .frame(width: 150, height: 150)
            .blur(radius: 110)
            .matchedGeometryEffect(id: "Circle", in: namespace)
    }
}

// MARK: - Body
extension OKIAPView {
    @ViewBuilder
    private func BodyView() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().height(32)
                TextChip()
                Spacer().height(12)
                HeroTitleText()
                Spacer().height(2)
                HeroSubtitleText()
                Spacer().height(24)
                FeatureView()
                Spacer().height(24)
                ProductListView()
            }
            .padding(.horizontal, 15)
            .padding(.bottom, bottomViewHeight + 16)
        }
        .scrollIndicators(.hidden)
    }
}

// MARK: - Dismiss Button
extension OKIAPView {
    @ViewBuilder
    private func DismissButton() -> some View {
        Button {
            onComplete()
        } label: {
            Group {
                if progress > iap.dismissDelay {
                    DismissButtonContent()
                } else {
                    CircularProgress()
                }
            }
        }
        .foregroundStyle(Color.white.opacity(0.2))
        .disabled(progress < iap.dismissDelay)
        .buttonStyle(.glass)
        .buttonBorderShape(isFromOnboarding ? .capsule : .circle)
        .padding(.horizontal, 15)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }

    @ViewBuilder
    private func DismissButtonContent() -> some View {
        Group {
            if isFromOnboarding {
                Text("Skip")
                    .font(font.title3)
            } else {
                Image(systemName: "multiply")
                    .font(.title3)
                    .frame(width: 20, height: 30)
            }
        }
    }

    @ViewBuilder
    private func CircularProgress() -> some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
                .frame(width: 20, height: 30)

            ProgressView(value: progress, total: iap.dismissDelay)
                .progressViewStyle(GaugeProgressStyle(strokeColor: .gray, strokeWidth: 2))
                .frame(width: 20, height: 30)
        }
    }
}

// MARK: - Hero
extension OKIAPView {
    @ViewBuilder
    private func TextChip() -> some View {
        Text(iap.chipText)
            .font(font.headline)
            .foregroundStyle(primaryColor)
            .padding(.vertical, 6)
            .padding(.horizontal, 16)
            .glassEffect(.regular)
    }

    @ViewBuilder
    private func HeroTitleText() -> some View {
        Text(iap.heroTitle)
            .font(font.displayLG)
            .foregroundStyle(
                LinearGradient(
                    colors: [.white, primaryColor],
                    startPoint: .topLeading,
                    endPoint: .topTrailing
                )
            )
    }

    @ViewBuilder
    private func HeroSubtitleText() -> some View {
        Text(iap.heroSubtitle)
            .font(font.title3)
            .foregroundStyle(Color.white.opacity(0.3))
    }
}

// MARK: - Feature Comparison
extension OKIAPView {
    @ViewBuilder
    private func FeatureView() -> some View {
        VStack(spacing: 0) {
            FeatureDetailView(text1: "FEATURE", text2: "Free", text3: "Pro", color: primaryColor)
                .background(Color.white.opacity(0.05))
                .clipShape(.rect(cornerRadii: RectangleCornerRadii(topLeading: 24, topTrailing: 24)))

            Divider()
            Divider()

            ForEach(iap.features) { feature in
                FeatureDetailView(
                    text1: feature.name,
                    text2: feature.freeValue,
                    text3: feature.proValue
                )
                Divider()
            }
        }
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: 24))
    }

    @ViewBuilder
    private func FeatureDetailView(
        text1: String,
        text2: String,
        text3: String,
        color: Color = Color(.systemGreen)
    ) -> some View {
        HStack(spacing: 0) {
            Text(text1)
                .foregroundStyle(Color.white.opacity(0.3))
                .frame(maxWidth: .infinity, alignment: .leading)

            Divider()

            Text(text2)
                .foregroundStyle(Color.white.opacity(0.3))
                .frame(width: 100, alignment: .center)

            Divider()

            Text(text3)
                .foregroundStyle(color)
                .frame(width: 100, alignment: .center)
        }
        .padding(.leading, 13)
        .font(font.bodyMedium)
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Products
extension OKIAPView {
    @ViewBuilder
    private func ProductListView() -> some View {
        VStack(spacing: 16) {
            ForEach(iap.products) { product in
                Button {
                    withAnimation {
                        currentIndex = product.id
                    }
                } label: {
                    ProductView(product: product)
                }
            }
        }
    }

    @ViewBuilder
    private func ProductView(product: ProductOption) -> some View {
        let isActive = currentIndex == product.id

        VStack(spacing: 0) {
            if let badge = product.badge {
                Text(badge)
                    .font(font.bodyMedium)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 6)
                    .background(primaryColor)
                    .foregroundStyle(Color.white)
            }

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .stroke(isActive ? primaryColor : Color.white.opacity(0.5), lineWidth: 2)
                        .frame(width: 32, height: 32)

                    if isActive {
                        Circle()
                            .fill(primaryColor)
                            .frame(width: 16, height: 16)
                    }
                }

                VStack(alignment: .leading, spacing: 0) {
                    Text(product.title)
                        .font(font.title2)
                        .foregroundStyle(Color.white)

                    Text(product.subtitle)
                        .font(font.footnoteMedium)
                        .foregroundStyle(Color.white.opacity(0.5))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 0) {
                    Text(product.price)
                        .font(font.title2)
                        .foregroundStyle(Color.white)

                    Text(product.secondaryPrice)
                        .font(font.footnoteMedium)
                        .foregroundStyle(Color.white.opacity(0.5))
                        .minimumScaleFactor(0.8)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 80)
        }
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay {
            RoundedRectangle(cornerRadius: 24)
                .stroke(primaryColor.opacity(isActive ? 1 : 0), lineWidth: 2)
        }
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 24))
    }
}

// MARK: - Bottom CTA
extension OKIAPView {
    @ViewBuilder
    private func BottomView() -> some View {
        VStack(spacing: 0) {
            FreeTrialText()
            Spacer().height(16)
            CTAButton()
            Spacer().height(10)
            OtherLinksView()
            Spacer().height(16)
            RestoreButton()
            Spacer().height(15)
        }
        .padding(15)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect)
        .onGeometryChange(for: CGSize.self) {
            $0.size
        } action: { newValue in
            bottomViewHeight = newValue.height
        }
    }

    @ViewBuilder
    private func FreeTrialText() -> some View {
        Text(iap.trialText)
            .font(font.body)
            .foregroundStyle(Color(.systemGreen))
    }

    @ViewBuilder
    private func CTAButton() -> some View {
        Button {
            onPurchase(currentIndex)
        } label: {
            VStack(spacing: 0) {
                Text(iap.ctaTitle)
                    .font(font.title2)

                Spacer().height(2)

                Text(iap.ctaSubtitle)
                    .font(font.body)
                    .foregroundStyle(Color.white.opacity(0.8))
            }
            .padding(.vertical, 6)
        }
        .tint(primaryColor)
        .buttonStyle(.glassProminent)
        .buttonSizing(.flexible)
        .padding(.horizontal, 15)
    }

    @ViewBuilder
    private func OtherLinksView() -> some View {
        HStack(spacing: 8) {
            Button {
                onTermsTapped()
            } label: {
                Text("Terms Of Use")
                    .font(font.footnote)
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            Text("\u{2022}")
                .font(font.footnote)
                .foregroundStyle(Color.white.opacity(0.5))

            Button {
                onPrivacyTapped()
            } label: {
                Text("Privacy Policy")
                    .font(font.footnote)
                    .foregroundStyle(Color.white.opacity(0.5))
            }

            Text("\u{2022}")
                .font(font.footnote)
                .foregroundStyle(Color.white.opacity(0.5))

            Text("Cancel Anytime")
                .font(font.footnote)
                .foregroundStyle(Color.white.opacity(0.5))
        }
    }

    @ViewBuilder
    private func RestoreButton() -> some View {
        Button {
            onRestore()
        } label: {
            Text("Restore Purchase")
                .underline()
                .font(font.bodyMedium)
                .foregroundStyle(Color.white.opacity(0.8))
        }
    }
}
