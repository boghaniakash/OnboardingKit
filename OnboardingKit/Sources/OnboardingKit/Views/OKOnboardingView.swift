//
//  OKOnboardingView.swift
//  OnboardingKit
//

import SwiftUI

struct OKOnboardingView: View {
    let configuration: OnboardingFlowConfiguration
    let namespace: Namespace.ID
    var onComplete: () -> Void

    @State private var currentIndex: Int = 0
    @State private var screenshotSize: CGSize = .zero

    private var pages: [PageConfiguration] { configuration.pages }
    private var font: FontTheme { configuration.font }
    private var primaryColor: Color { configuration.primaryColor }

    var body: some View {
        ZStack(alignment: .topLeading) {
            BlurCircleBG()
            BodyView()
        }
    }
}

// MARK: - Body
extension OKOnboardingView {
    @ViewBuilder
    private func BodyView() -> some View {
        ZStack(alignment: .bottom) {
            ScreenshotView()
                .compositingGroup()
                .scaleEffect(
                    pages[currentIndex].zoomScale,
                    anchor: pages[currentIndex].zoomAnchor
                )
                .padding(.top, 35)
                .padding(.horizontal, 30)
                .padding(.bottom, 220)

            VStack(spacing: 10) {
                TextContentView()
                IndicatorView()
                ContinueButton()
            }
            .padding(.top, 20)
            .padding(.horizontal, 15)
            .frame(height: 210)
            .background {
                VariableGlassBlur(18)
            }

            if currentIndex != 0 {
                BackButton()
            }
        }
    }
}

// MARK: - Background
extension OKOnboardingView {
    @ViewBuilder
    private func BlurCircleBG() -> some View {
        Circle()
            .fill(primaryColor)
            .frame(width: 150, height: 150)
            .blur(radius: 90)
            .matchedGeometryEffect(id: "Circle", in: namespace)
    }
}

// MARK: - Buttons
extension OKOnboardingView {
    @ViewBuilder
    private func ContinueButton() -> some View {
        let isLastPage = currentIndex == pages.count - 1

        Button {
            if isLastPage {
                onComplete()
            }
            withAnimation(animation) {
                currentIndex = min(currentIndex + 1, pages.count - 1)
            }
        } label: {
            Text(isLastPage ? "Get Started" : "Continue")
                .font(font.ctaPrimary)
                .contentTransition(.numericText())
                .padding(.vertical, 8)
        }
        .tint(primaryColor)
        .buttonStyle(.glassProminent)
        .buttonSizing(.flexible)
        .padding(.horizontal, 30)
    }

    @ViewBuilder
    private func BackButton() -> some View {
        Button {
            withAnimation(animation) {
                currentIndex = max(currentIndex - 1, 0)
            }
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3)
                .frame(width: 20, height: 30)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.leading, 15)
    }
}

// MARK: - Screenshot
extension OKOnboardingView {
    @ViewBuilder
    private func ScreenshotView() -> some View {
        let shape = ConcentricRectangle(corners: .concentric, isUniform: true)

        GeometryReader {
            let size = $0.size

            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(pages.indices, id: \.self) { index in
                        let page = pages[index]

                        Group {
                            if let screenshot = page.image {
                                Image(uiImage: screenshot)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .onGeometryChange(for: CGSize.self) {
                                        $0.size
                                    } action: { newValue in
                                        screenshotSize = newValue
                                    }
                                    .clipShape(shape)
                            } else {
                                Rectangle()
                                    .fill(.black)
                            }
                        }
                        .frame(width: size.width, height: size.height)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                return currentIndex
            }, set: { _ in }))
        }
        .clipShape(shape)
        .overlay {
            if screenshotSize != .zero {
                ZStack {
                    shape.stroke(.white, lineWidth: 6)
                    shape.stroke(.black, lineWidth: 4)
                    shape.stroke(.black, lineWidth: 6).padding(4)
                }
                .padding(-6)
            }
        }
        .frame(
            maxWidth: screenshotSize.width == 0 ? nil : screenshotSize.width,
            maxHeight: screenshotSize.height == 0 ? nil : screenshotSize.height
        )
        .containerShape(RoundedRectangle(cornerRadius: deviceCornerRadius))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Text Content
extension OKOnboardingView {
    @ViewBuilder
    private func TextContentView() -> some View {
        GeometryReader {
            let size = $0.size

            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    ForEach(pages.indices, id: \.self) { index in
                        let page = pages[index]
                        let isActive = currentIndex == index

                        VStack(spacing: 6) {
                            Text(page.title)
                                .font(font.title2)
                                .lineLimit(1)

                            Text(page.subtitle)
                                .font(font.callout)
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .foregroundStyle(Color.white.opacity(0.8))
                        }
                        .frame(width: size.width)
                        .compositingGroup()
                        .blur(radius: isActive ? 0 : 30)
                        .opacity(isActive ? 1 : 0)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollDisabled(true)
            .scrollTargetBehavior(.paging)
            .scrollClipDisabled()
            .scrollPosition(id: .init(get: {
                return currentIndex
            }, set: { _ in }))
        }
    }
}

// MARK: - Indicator
extension OKOnboardingView {
    @ViewBuilder
    private func IndicatorView() -> some View {
        HStack(spacing: 6) {
            ForEach(pages.indices, id: \.self) { index in
                let isActive = index == currentIndex

                Capsule()
                    .fill(.white.opacity(isActive ? 1 : 0.4))
                    .frame(width: isActive ? 25 : 6, height: 6)
            }
        }
    }

    @ViewBuilder
    private func VariableGlassBlur(_ radius: CGFloat) -> some View {
        let tint: Color = .black.opacity(0.5)
        Rectangle()
            .fill(.clear)
            .glassEffect(.clear.tint(tint), in: .rect)
            .blur(radius: radius)
            .padding([.horizontal, .bottom], -radius * 2)
            .opacity(pages[currentIndex].zoomScale != 1 ? 1 : 0)
            .ignoresSafeArea()
    }
}

// MARK: - Computed Properties
extension OKOnboardingView {
    private var animation: Animation {
        .interpolatingSpring(duration: 0.65, bounce: 0, initialVelocity: 0)
    }

    private var deviceCornerRadius: CGFloat {
        if let imageSize = pages.first?.image?.size {
            let ratio = screenshotSize.height / imageSize.height
            let actualCornerRadius: CGFloat = 190
            return actualCornerRadius * ratio
        }
        return 0
    }
}
