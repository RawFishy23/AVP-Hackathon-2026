import SwiftUI

struct CodeBlackView: View {
    @Environment(EncounterSession.self) private var session

    private enum Stage: Int, CaseIterable {
        case notifying, dispatched, onScene

        var label: String {
            switch self {
            case .notifying: return "Notifying Security…"
            case .dispatched: return "Security Dispatched"
            case .onScene: return "Security On Scene"
            }
        }

        var icon: String {
            switch self {
            case .notifying: return "antenna.radiowaves.left.and.right"
            case .dispatched: return "figure.walk"
            case .onScene: return "checkmark.shield.fill"
            }
        }
    }

    @State private var stage: Stage = .notifying
    @State private var startedAt = Date()

    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.octagon.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(.red)
                Text("CODE BLACK ACTIVATED")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Text("Aggressive / violent visitor — front desk reception")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.7))
            }

            VStack(spacing: 16) {
                ForEach(Stage.allCases, id: \.self) { step in
                    HStack(spacing: 12) {
                        Image(systemName: step.icon)
                            .foregroundStyle(step.rawValue <= stage.rawValue ? .green : .white.opacity(0.3))
                        Text(step.label)
                            .font(.system(size: 17, weight: step == stage ? .semibold : .regular))
                            .foregroundStyle(step.rawValue <= stage.rawValue ? .white : .white.opacity(0.4))
                        Spacer()
                        if step.rawValue < stage.rawValue {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.green)
                        } else if step == stage {
                            ProgressView()
                        }
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }

            Spacer()

            if stage == .onScene {
                NavigationLink(value: EncounterRoute.results) {
                    Text("Continue")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.healthBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .hoverEffect()
            }
        }
        .padding(40)
        .frame(maxWidth: 700)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .padding(60)
        .navigationTitle("Code Black")
        .task {
            session.codeBlackCalled = true
            await runSequence()
        }
    }

    private func runSequence() async {
        for next in [Stage.dispatched, .onScene] {
            try? await Task.sleep(for: .seconds(1.5))
            await MainActor.run { stage = next }
        }
        await MainActor.run {
            session.codeBlackResponseSeconds = Date().timeIntervalSince(startedAt)
        }
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        CodeBlackView()
    }
    .environment(EncounterSession())
}
