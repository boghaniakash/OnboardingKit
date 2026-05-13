# OnboardingKit

A drop-in SwiftUI package for building **Liquid Glass** onboarding flows, paywalls, settings screens, and reusable components — designed for iOS 26+.

OnboardingKit provides a complete, configuration-driven UI layer that stays consistent across all your apps while letting you customize content, colors, and fonts per-app.

---

## Requirements

- **iOS 26+**
- **Swift 6.2+**
- **Xcode 26+**

## Installation

### Swift Package Manager

Add the package in Xcode via **File > Add Package Dependencies**, or add it to your `Package.swift`:

```swift
dependencies: [
    .package(path: "../Packages/OnboardingKit")
    // or .package(url: "https://your-repo-url/OnboardingKit.git", from: "1.0.0")
]
```

Then import it:

```swift
import OnboardingKit
```

---

## Overview

| Feature | Description |
|---|---|
| **Onboarding Flow** | Splash -> Paginated walkthrough -> IAP paywall |
| **Standalone Paywall** | Open the IAP screen from anywhere (e.g. Settings) |
| **Glass Tab Bar** | Segmented control tab bar with Liquid Glass |
| **Typewriter TextField** | Animated placeholder search bar |
| **Settings Screen** | Pre-built glass settings shell with rows, sections, toggles |
| **Theming** | Global font + color propagation via SwiftUI environment |

---

## Theming

All OnboardingKit views read their font scale and accent color from the SwiftUI environment. Apply `.okStyle()` on any ancestor to theme everything beneath it.

```swift
// Using a configuration object
TabView {
    HomeView()
    SettingsView()
}
.okStyle(from: .myAppConfig)

// Or set font and color directly
ContentView()
    .okStyle(font: myFontTheme, primaryColor: .indigo)
```

### FontTheme

Define a custom font scale, or use `.system` for the default system fonts:

```swift
let myFont = FontTheme(
    regular: "Celias",
    medium: "Celias-Medium",
    bold: "Celias-Bold",
    black: "Celias-Black"
)
```

`FontTheme` provides a full typographic scale: `displayXL`, `largeTitle`, `title1`...`title3`, `headline`, `body`, `bodyMedium`, `callout`, `footnote`, `caption1`, `caption2`, and their medium/bold variants — all with Dynamic Type support.

### Environment Keys

```swift
@Environment(\.okFont) var font           // FontTheme (default: .system)
@Environment(\.okPrimaryColor) var color  // Color (default: .blue)
```

---

## Onboarding Flow

The full Splash -> Onboarding -> IAP flow in a single view, driven by configuration.

### Configuration

```swift
extension OnboardingFlowConfiguration {
    static let myApp = OnboardingFlowConfiguration(
        splash: SplashConfiguration(
            icon: "doc.viewfinder",
            title: "DocScanner",
            subtitle: "Scan, Store, Share"
        ),
        pages: [
            PageConfiguration(
                id: 0,
                image: UIImage(named: "onboard1"),
                title: "Scan Anything",
                subtitle: "Point your camera at any document."
            ),
            PageConfiguration(
                id: 1,
                image: UIImage(named: "onboard2"),
                title: "Organize Instantly",
                subtitle: "Auto-sort into smart folders.",
                zoomScale: 1.2,
                zoomAnchor: .top
            ),
            PageConfiguration(
                id: 2,
                image: UIImage(named: "onboard3"),
                title: "Share as PDF",
                subtitle: "Export and share in one tap."
            )
        ],
        iap: IAPConfiguration(
            features: [
                FeatureRow(id: 0, name: "Scans per month", freeValue: "5", proValue: "Unlimited"),
                FeatureRow(id: 1, name: "Cloud Backup", freeValue: "---", proValue: "checkmark"),
                FeatureRow(id: 2, name: "OCR Text", freeValue: "---", proValue: "checkmark"),
            ],
            products: [
                ProductOption(
                    id: 0,
                    title: "Weekly",
                    subtitle: "Billed every week",
                    price: "$1.99",
                    secondaryPrice: "$1.99/wk"
                ),
                ProductOption(
                    id: 1,
                    title: "Annual",
                    subtitle: "Billed once a year",
                    price: "$29.99",
                    secondaryPrice: "$0.58/wk",
                    badge: "BEST VALUE"
                ),
            ],
            ctaTitle: "Start Free Trial",
            ctaSubtitle: "Then $29.99/yr - Cancel anytime"
        ),
        primaryColor: Color(.systemIndigo),
        font: .system
    )
}
```

### Usage

```swift
@main
struct MyApp: App {
    @State private var showOnboarding = true

    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingFlowView(
                    configuration: .myApp,
                    onSplashAppear: {
                        // Perform async setup (load data, configure SDK, etc.)
                        await loadInitialData()
                    },
                    onComplete: {
                        showOnboarding = false
                    },
                    onPurchase: { productIndex in
                        // Handle StoreKit purchase
                    },
                    onRestore: {
                        // Handle restore purchases
                    }
                )
            } else {
                ContentView()
            }
        }
    }
}
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `configuration` | `OnboardingFlowConfiguration` | required | All content and styling |
| `onSplashAppear` | `() async -> Void` | `{}` | Async work to run while splash is visible |
| `onComplete` | `() -> Void` | required | Called when user finishes or skips IAP |
| `onPurchase` | `(Int) -> Void` | `{ _ in }` | Receives the selected `ProductOption.id` |
| `onRestore` | `() -> Void` | `{}` | Called when user taps restore |
| `onTermsTapped` | `() -> Void` | `{}` | Called when user taps Terms |
| `onPrivacyTapped` | `() -> Void` | `{}` | Called when user taps Privacy |

---

## Standalone Paywall

Open the IAP screen independently from anywhere in your app (e.g., a Settings "Upgrade" button). Shows a close button (`x`) instead of the onboarding "Skip" pill.

```swift
struct SettingsView: View {
    @State private var showPaywall = false

    var body: some View {
        OKProBanner { showPaywall = true }
            .fullScreenCover(isPresented: $showPaywall) {
                PaywallView(
                    configuration: .myApp,
                    onComplete: { showPaywall = false },
                    onPurchase: { productIndex in
                        // Handle purchase
                    },
                    onRestore: {
                        // Handle restore
                    }
                )
            }
    }
}
```

---

## Glass Tab Bar

A Liquid Glass segmented tab bar with an optional floating action button. Uses `UISegmentedControl` under the hood for native segment rendering.

### 1. Define Your Tabs

Conform your tab enum to `OKTabItem`:

```swift
enum AppTab: String, CaseIterable, OKTabItem {
    case home = "Home"
    case history = "History"
    case settings = "Settings"

    var title: String { rawValue }

    var symbol: String {
        switch self {
        case .home: "house.fill"
        case .history: "clock.fill"
        case .settings: "gearshape.fill"
        }
    }
}
```

### 2. Use in a TabView

```swift
struct MainTabView: View {
    @State private var activeTab: AppTab = .home

    var body: some View {
        TabView(selection: $activeTab) {
            Tab(value: .home) {
                HomeView()
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            Tab(value: .history) {
                HistoryView()
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
            Tab(value: .settings) {
                SettingsView()
                    .toolbarVisibility(.hidden, for: .tabBar)
            }
        }
        .okStyle(from: .myApp)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            // With an action button
            OKGlassTabBar(activeTab: $activeTab) {
                Button("Scan", systemImage: "document.viewfinder.fill") {
                    // action
                }
                .labelStyle(.iconOnly)
                .font(.title3)
                .foregroundStyle(.white)
                .frame(width: 55, height: 55)
                .glassEffect(.regular.interactive(), in: .circle)
            }
            .padding(.horizontal, 20)

            // Or without an action button:
            // OKGlassTabBar(activeTab: $activeTab)
        }
    }
}
```

---

## Typewriter TextField

An animated search bar whose placeholder text types and erases through a list of strings. Supports an optional `prefix` and customizable trailing content.

### Basic (no trailing content)

```swift
@State private var query = ""

OKTypewriterTextField(
    text: $query,
    placeholders: ["\"Photos\"", "\"Documents\"", "\"Invoices\""]
)
```

### With Prefix + Clear Button

```swift
OKTypewriterTextField(
    text: $searchText,
    placeholders: ["\"Tax Return\"", "\"Invoice\"", "\"Passport\""],
    prefix: "Search "
) {
    Rectangle()
        .fill(Color.gray)
        .frame(width: 1, height: 30)
        .clipShape(Capsule())

    Button("Clear", systemImage: "xmark.circle.fill") {
        searchText = ""
    }
    .labelStyle(.iconOnly)
    .font(.title3)
    .foregroundStyle(Color.white.opacity(searchText.isEmpty ? 0.3 : 0.6))
    .disabled(searchText.isEmpty)
    .padding(.leading, 4)
}
```

### With Prefix + Microphone Button

```swift
OKTypewriterTextField(
    text: $searchText,
    placeholders: ["\"Annual Report\"", "\"Budget\"", "\"Meeting Notes\""],
    prefix: "Search "
) {
    Rectangle()
        .fill(Color.gray)
        .frame(width: 1, height: 30)
        .clipShape(Capsule())

    Button("Voice", systemImage: "microphone.fill") {
        // Start speech recognition
    }
    .labelStyle(.iconOnly)
    .font(.title3)
    .foregroundStyle(.white)
    .padding(.leading, 4)
}
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `Binding<String>` | required | The search text binding |
| `placeholders` | `[String]` | required | Strings to cycle through |
| `prefix` | `String` | `""` | Static text before the animated portion |
| `icon` | `String` | `"magnifyingglass"` | Leading SF Symbol |
| `typingSpeed` | `Duration` | `.milliseconds(50)` | Delay per character typed |
| `erasingSpeed` | `Duration` | `.milliseconds(30)` | Delay per character erased |
| `pauseDuration` | `Duration` | `.seconds(2.5)` | Pause between words |
| `trailingContent` | `@ViewBuilder` | `EmptyView` | Custom trailing buttons/icons |

---

## Settings Screen

A complete settings UI system with a glass navigation bar, grouped sections, and multiple row types.

### Full Example

```swift
struct SettingsView: View {
    @State private var path: [Destination] = []
    @State private var iCloudSync = true
    @State private var faceIdLock = false
    @State private var showPaywall = false

    var body: some View {
        NavigationStack(path: $path) {
            OKSettingsScreen(title: "Settings", subtitle: "Preferences & Account") {
                // Nav bar trailing buttons
                Button("Notifications", systemImage: "bell.badge.fill") {}
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color(.systemYellow))
                    .glassEffect(.regular.interactive(), in: .circle)
            } content: {
                // Pro Banner
                OKProBanner { showPaywall = true }

                // Grouped Section
                OKSection("General") {
                    OKNavigationRow(
                        icon: "doc.text.fill",
                        iconTint: .blue,
                        title: "PDF Quality",
                        subtitle: "Ultra HD"
                    ) {
                        path.append(.pdfQuality)
                    }

                    Divider()

                    OKNavigationRow(
                        icon: "camera.fill",
                        iconTint: .orange,
                        title: "Camera Settings",
                        subtitle: "Auto-enhance on"
                    ) {
                        path.append(.camera)
                    }
                }

                // Toggle Section
                OKSection("Storage & Sync") {
                    OKToggleRow(
                        icon: "icloud.fill",
                        iconTint: Color(.systemCyan),
                        title: "iCloud Sync",
                        isOn: $iCloudSync
                    )

                    Divider()

                    OKToggleRow(
                        icon: "faceid",
                        iconTint: Color(.systemGreen),
                        title: "Face ID Lock",
                        isOn: $faceIdLock
                    )
                }

                // Static Rows
                OKSection("About") {
                    OKRow(icon: "star.fill", iconTint: Color(.systemYellow), title: "Rate Us")
                    Divider()
                    OKRow(icon: "envelope.fill", iconTint: Color(.systemPurple), title: "Contact Support")
                }

                // Footer
                OKAppInfoFooter(appName: "MyApp", version: "1.0.0")
            }
            .okStyle(from: .myApp)
        }
    }
}
```

### Settings Components

| Component | Description |
|---|---|
| `OKSettingsScreen` | Full-screen shell with glass nav bar + scroll view |
| `OKSection("Title") { ... }` | Uppercase-labelled glass card group |
| `OKNavigationRow` | Tappable row with icon, title, subtitle, chevron |
| `OKToggleRow` | Row with icon, title, and a toggle switch |
| `OKRow` | Static display row with icon, title, chevron |
| `OKProBanner` | Upgrade-to-pro promotional card |
| `OKAppInfoFooter` | Centered app name + version footer |

---

## Architecture

```
OnboardingKit/
├── Configuration/
│   ├── FontTheme.swift              # Type-safe font scale
│   └── OnboardingFlowConfiguration  # Master config + sub-configs
├── Public/
│   ├── OnboardingFlowView.swift     # Full onboarding entry point
│   └── PaywallView.swift            # Standalone IAP paywall
├── Views/
│   ├── OKSplashView.swift           # Animated splash (internal)
│   ├── OKOnboardingView.swift       # Paginated walkthrough (internal)
│   └── OKIAPView.swift              # IAP paywall (internal)
├── Components/
│   ├── OKGlassTabBar.swift          # Glass segmented tab bar + OKTabItem
│   └── OKTypewriterTextField.swift  # Animated placeholder search bar
├── Settings/
│   ├── OKSettingsScreen.swift       # Settings shell
│   ├── OKSettingsComponents.swift   # Section, ProBanner, Footer
│   └── OKSettingsRows.swift         # Row, NavigationRow, ToggleRow
└── Internal/
    ├── Environment+OnboardingKit.swift  # okFont, okPrimaryColor, .okStyle()
    ├── SpacerExtensions.swift           # Spacer().height() / .width()
    └── GaugeProgressStyle.swift         # Countdown ring style
```

---

## License

MIT
