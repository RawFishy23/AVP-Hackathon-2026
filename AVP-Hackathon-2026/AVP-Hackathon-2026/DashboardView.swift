//
//  DashboardView.swift
//  AVP-Hackathon-2026
//

import SwiftUI

struct DashboardView: View {
    @Environment(AppModel.self) private var appModel
    @Environment(EncounterSession.self) private var encounterSession
    @State private var detailPath: [EncounterRoute] = []

    var body: some View {
        @Bindable var appModel = appModel

        NavigationSplitView {
            // ── Column 1: Module sidebar ───────────────────────────────
            ModuleSidebarView(selectedModule: $appModel.selectedModule)

        } content: {
            // ── Column 2: Scenario grid ────────────────────────────────
            if let module = appModel.selectedModule {
                ScenarioGridView(module: module)
            } else {
                EmptySelectionView(
                    systemImage: "sidebar.left",
                    message: "Choose a module to see its scenarios."
                )
            }

        } detail: {
            // ── Column 3: Scenario preview, plus the post-encounter
            //    Code Black / Results screens pushed on top of it.
            NavigationStack(path: $detailPath) {
                Group {
                    if let scenario = appModel.selectedScenario {
                        ScenarioPreviewView(scenario: scenario)
                    } else {
                        EmptySelectionView(
                            systemImage: "play.rectangle",
                            message: "Select a scenario to preview it."
                        )
                    }
                }
                .navigationDestination(for: EncounterRoute.self) { route in
                    switch route {
                    case .codeBlack:
                        CodeBlackView()
                    case .results:
                        ResultsView()
                    }
                }
            }
        }
        .onAppear {
            wireEncounterCallbacks()
        }
    }

    private func wireEncounterCallbacks() {
        encounterSession.advanceToCodeBlack = { detailPath.append(.codeBlack) }
        encounterSession.resetFlow = {
            detailPath.removeAll()
            if let scenario = appModel.selectedScenario {
                appModel.markCompleted(scenario)
            }
            appModel.dismissPreview()
        }
        encounterSession.retryFlow = {
            encounterSession.reset()
            detailPath.removeAll()
        }
    }
}

// MARK: - Empty state helper

private struct EmptySelectionView: View {
    let systemImage: String
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(message)
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(40)
    }
}

#Preview(windowStyle: .automatic) {
    DashboardView()
        .environment(AppModel())
        .environment(EncounterSession())
}
