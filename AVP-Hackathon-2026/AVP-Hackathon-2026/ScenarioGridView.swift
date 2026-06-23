//
//  ScenarioGridView.swift
//  AVP-Hackathon-2026
//
//  Created by Carson Hizkia on 23/06/2026.
//


//
//  ScenarioGridView.swift
//  AVP-Hackathon-2026
//

import SwiftUI

struct ScenarioGridView: View {
    @Environment(AppModel.self) private var appModel
    let module: TrainingModule

    // ── Layout constants (tweak here) ─────────────────────────────────────
    private let columns = [
        GridItem(.adaptive(minimum: 260, maximum: 320), spacing: 20)
    ]
    private let cardCornerRadius: CGFloat = 20
    // ──────────────────────────────────────────────────────────────────────

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(module.scenarios) { scenario in
                    ScenarioCard(scenario: scenario, accentColor: module.accentColor) {
                        appModel.selectScenario(scenario)
                    }
                }
            }
            .padding(24)
        }
        .navigationTitle(module.title)
    }
}

// MARK: - Card

struct ScenarioCard: View {
    let scenario: Scenario
    let accentColor: Color
    let onTap: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {

                // ── Thumbnail area ─────────────────────────────────────
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(accentColor.opacity(0.12))
                        .frame(height: 140)

                    Image(systemName: scenario.thumbnailSystemImage)
                        .font(.system(size: 44, weight: .light))
                        .foregroundStyle(accentColor.opacity(0.7))

                    // Completed badge
                    if scenario.isCompleted {
                        VStack {
                            HStack {
                                Spacer()
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                                    .font(.title3)
                                    .padding(10)
                            }
                            Spacer()
                        }
                    }
                }

                // ── Card body ──────────────────────────────────────────
                VStack(alignment: .leading, spacing: 8) {
                    Text(scenario.title)
                        .font(.headline)
                        .lineLimit(2)

                    Text(scenario.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)

                    Spacer(minLength: 8)

                    // Metadata row
                    HStack(spacing: 8) {
                        // Difficulty pill
                        Label(scenario.difficulty.rawValue, systemImage: scenario.difficulty.systemImage)
                            .font(.caption.bold())
                            .foregroundStyle(scenario.difficulty.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(scenario.difficulty.color.opacity(0.15), in: Capsule())

                        // Category pill
                        Text(scenario.category)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(.secondary.opacity(0.12), in: Capsule())

                        Spacer()

                        // Duration
                        Label(scenario.duration, systemImage: "clock")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(16)
            }
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(accentColor.opacity(isHovered ? 0.5 : 0.0), lineWidth: 1.5)
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(duration: 0.25), value: isHovered)
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
    }
}
