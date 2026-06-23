//
//  ScenarioPreviewView.swift
//  AVP-Hackathon-2026
//
//  Created by Carson Hizkia on 23/06/2026.
//


//
//  ScenarioPreviewView.swift
//  AVP-Hackathon-2026
//

import SwiftUI
import AVKit

struct ScenarioPreviewView: View {
    @Environment(AppModel.self) private var appModel
    let scenario: Scenario

    // ── Layout constants ───────────────────────────────────────────────────
    private let videoAspectRatio: CGFloat = 16 / 9
    private let cornerRadius: CGFloat = 20
    // ──────────────────────────────────────────────────────────────────────

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {

                // ── Video / Thumbnail area ─────────────────────────────
                VideoThumbnailView(
                    videoName: scenario.videoName,
                    placeholderIcon: scenario.thumbnailSystemImage
                )
                .aspectRatio(videoAspectRatio, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

                // ── Metadata strip ─────────────────────────────────────
                HStack(spacing: 12) {
                    Label(scenario.difficulty.rawValue, systemImage: scenario.difficulty.systemImage)
                        .font(.subheadline.bold())
                        .foregroundStyle(scenario.difficulty.color)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(scenario.difficulty.color.opacity(0.15), in: Capsule())

                    Label(scenario.category, systemImage: "tag")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.secondary.opacity(0.1), in: Capsule())

                    Label(scenario.duration, systemImage: "clock")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.secondary.opacity(0.1), in: Capsule())
                }

                // ── Detail description ─────────────────────────────────
                VStack(alignment: .leading, spacing: 10) {
                    Text("Overview")
                        .font(.title3.bold())

                    Text(scenario.detailDescription)
                        .font(.body)
                        .foregroundStyle(.secondary)
                        .lineSpacing(5)
                }

                Spacer(minLength: 40)
            }
            .padding(28)
        }
        .navigationTitle(scenario.title)
        .toolbar {
            // ── Back button (top-left, after sidebar toggle) ───────────
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    appModel.dismissPreview()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
            }

            // ── Play button (top-right) ────────────────────────────────
            ToolbarItem(placement: .primaryAction) {
                PlayButton(scenario: scenario)
            }
        }
    }
}

// MARK: - Play Button

private struct PlayButton: View {
    @Environment(AppModel.self) private var appModel
    let scenario: Scenario
    @State private var isConfirming = false

    var body: some View {
        Button {
            isConfirming = true
        } label: {
            Label("Play Scenario", systemImage: "play.fill")
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(.blue, in: Capsule())
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        // ── Replace this alert with your actual scenario launch logic ──
        .alert("Launch Scenario", isPresented: $isConfirming) {
            Button("Begin") {
                appModel.markCompleted(scenario)
                // TODO: trigger immersive space or scenario engine here
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Start \"\(scenario.title)\"? This will launch the immersive training environment.")
        }
    }
}

// MARK: - Video / Thumbnail

/// Shows an AVPlayer when a videoName is provided, otherwise a styled placeholder.
private struct VideoThumbnailView: View {
    let videoName: String?
    let placeholderIcon: String

    var body: some View {
        if let name = videoName,
           let url = Bundle.main.url(forResource: name, withExtension: "mp4") {
            VideoPlayer(player: AVPlayer(url: url))
        } else {
            // Placeholder — replace with real thumbnail image when available
            ZStack {
                Rectangle()
                    .fill(.ultraThinMaterial)

                VStack(spacing: 16) {
                    Image(systemName: placeholderIcon)
                        .font(.system(size: 64, weight: .light))
                        .foregroundStyle(.secondary)
                    Text("Video Coming Soon")
                        .font(.subheadline)
                        .foregroundStyle(.tertiary)
                }
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        ScenarioPreviewView(scenario: TrainingData.all[0].scenarios[0])
            .environment(AppModel())
    }
}