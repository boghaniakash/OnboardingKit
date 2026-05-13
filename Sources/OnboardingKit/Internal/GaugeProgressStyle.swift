//
//  GaugeProgressStyle.swift
//  OnboardingKit
//

import SwiftUI

struct GaugeProgressStyle: ProgressViewStyle {
    var strokeColor: Color
    var strokeWidth: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0

        ZStack {
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}
