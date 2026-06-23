//
//  ModuleSidebarView.swift
//  AVP-Hackathon-2026
//
//  Created by Carson Hizkia on 23/06/2026.
//


//
//  ModuleSidebarView.swift
//  AVP-Hackathon-2026
//

import SwiftUI

struct ModuleSidebarView: View {
    @Environment(AppModel.self) private var appModel
    @Binding var selectedModule: TrainingModule?

    var body: some View {
        List(appModel.modules, selection: $selectedModule) { module in
            ModuleSidebarRow(module: module)
                .tag(module)
        }
        .listStyle(.sidebar)
        .navigationTitle("Training")
    }
}

// MARK: - Row

private struct ModuleSidebarRow: View {
    let module: TrainingModule

    var body: some View {
        HStack(spacing: 14) {

            // Icon + completion ring
            ZStack {
                // Background circle
                Circle()
                    .fill(module.accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)

                // Completion arc
                Circle()
                    .trim(from: 0, to: module.completionFraction)
                    .stroke(module.accentColor, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 44, height: 44)

                // SF symbol
                Image(systemName: module.systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(module.accentColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 2) {
                Text(module.title)
                    .font(.headline)
                Text(module.subtitle)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Scenario count badge
            Text("\(module.scenarios.count)")
                .font(.caption2.bold())
                .foregroundStyle(.secondary)
                .padding(.horizontal, 7)
                .padding(.vertical, 3)
                .background(.secondary.opacity(0.15), in: Capsule())
        }
        .padding(.vertical, 4)
    }
}