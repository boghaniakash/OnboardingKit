//
//  OKGlassTabBar.swift
//  OnboardingKit
//
//  A reusable glass tab bar with a segmented control and an optional action button.
//  Use inside `.safeAreaInset(edge: .bottom)` of a TabView.
//

import SwiftUI

// MARK: - Tab Item Protocol

public protocol OKTabItem: Hashable, CaseIterable where AllCases == [Self] {
    var title: String { get }
    var symbol: String { get }
}

extension OKTabItem {
    public var index: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

// MARK: - Glass Tab Bar

public struct OKGlassTabBar<Tab: OKTabItem, ActionButton: View>: View {
    @Binding var activeTab: Tab
    @ViewBuilder let actionButton: () -> ActionButton

    @Environment(\.okFont) private var font
    @Environment(\.okPrimaryColor) private var primaryColor

    public init(
        activeTab: Binding<Tab>,
        @ViewBuilder actionButton: @escaping () -> ActionButton
    ) {
        self._activeTab = activeTab
        self.actionButton = actionButton
    }

    public var body: some View {
        GlassEffectContainer(spacing: 8) {
            HStack(spacing: 8) {
                GeometryReader { proxy in
                    OKSegmentedControl(
                        size: proxy.size,
                        activeTint: primaryColor,
                        activeTab: $activeTab
                    ) { tab in
                        VStack(spacing: 3) {
                            Image(systemName: tab.symbol)
                                .font(.title3)

                            Text(tab.title)
                                .font(font.caption2Medium)
                        }
                        .symbolVariant(.fill)
                        .frame(maxWidth: .infinity)
                    }
                    .glassEffect(.regular.interactive(), in: .capsule)
                }

                actionButton()
            }
            .frame(height: 55)
        }
    }
}

// MARK: - Convenience init without action button

extension OKGlassTabBar where ActionButton == EmptyView {
    public init(activeTab: Binding<Tab>) {
        self._activeTab = activeTab
        self.actionButton = { EmptyView() }
    }
}

// MARK: - Segmented Control (UIViewRepresentable)

struct OKSegmentedControl<Tab: OKTabItem, TabItemView: View>: UIViewRepresentable {
    var size: CGSize
    var activeTint: Color
    var barTint: Color = .gray.opacity(0.15)

    @Binding var activeTab: Tab
    @ViewBuilder var tabItemView: (Tab) -> TabItemView

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UISegmentedControl {
        let allCases = Tab.allCases
        let items = allCases.map(\.title)
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = activeTab.index

        for (index, tab) in allCases.enumerated() {
            let renderer = ImageRenderer(content: tabItemView(tab))
            renderer.scale = 2
            let image = renderer.uiImage
            control.setImage(image, forSegmentAt: index)
        }

        Task { @MainActor in
            for subview in control.subviews {
                if subview is UIImageView && subview != control.subviews.last {
                    subview.alpha = 0
                }
            }
        }

        control.setTitleTextAttributes([.foregroundColor: UIColor(activeTint)], for: .selected)
        control.selectedSegmentTintColor = UIColor(barTint)
        control.addTarget(context.coordinator, action: #selector(context.coordinator.tabSelected(_:)), for: .valueChanged)
        return control
    }

    func updateUIView(_ uiView: UISegmentedControl, context: Context) {}

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UISegmentedControl, context: Context) -> CGSize? {
        return size
    }

    class Coordinator: NSObject {
        var parent: OKSegmentedControl

        init(parent: OKSegmentedControl) {
            self.parent = parent
        }

        @objc func tabSelected(_ control: UISegmentedControl) {
            let allCases = Tab.allCases
            guard control.selectedSegmentIndex < allCases.count else { return }
            parent.activeTab = allCases[control.selectedSegmentIndex]
        }
    }
}
