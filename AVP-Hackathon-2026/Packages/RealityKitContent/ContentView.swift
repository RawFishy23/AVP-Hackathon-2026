import SwiftUI

struct ContentView: View {
    @State private var selectedModule: TrainingModule? = TrainingModule.all.first
    @State private var selectedScenario: Scenario? = nil

    var body: some View {
        NavigationSplitView {
            // ── SIDEBAR ──────────────────────────────
            SidebarView(selectedModule: $selectedModule)
                .navigationSplitViewColumnWidth(220)

        } content: {
            // ── SCENARIO GRID ─────────────────────────
            if let module = selectedModule {
                ScenarioGridView(
                    module: module,
                    selectedScenario: $selectedScenario
                )
                .navigationSplitViewColumnWidth(min: 420, ideal: 560)
            } else {
                EmptySelectionView()
            }

        } detail: {
            // ── PREVIEW PANEL ─────────────────────────
            if let scenario = selectedScenario {
                ScenarioPreviewView(scenario: scenario)
            } else {
                PreviewPlaceholderView()
            }
        }
        .navigationSplitViewStyle(.balanced)
        // Clear scenario selection when module changes
        .onChange(of: selectedModule) {
            selectedScenario = nil
        }
    }
}
