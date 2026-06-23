//
//  AppModel.swift
//  AVP-Hackathon-2026
//

import SwiftUI

@MainActor
@Observable
class AppModel {

    // MARK: - Immersive Space

    let immersiveSpaceID = "ImmersiveSpace"

    enum ImmersiveSpaceState {
        case closed, inTransition, open
    }
    var immersiveSpaceState = ImmersiveSpaceState.closed

    // MARK: - Training Navigation

    /// All modules — mutate these to update completion state etc.
    var modules: [TrainingModule] = TrainingData.all

    /// Currently selected module in the sidebar
    var selectedModule: TrainingModule?

    /// Scenario selected for preview
    var selectedScenario: Scenario?

    /// Whether the scenario preview sheet / column is visible
    var isShowingPreview: Bool = false

    // MARK: - Actions

    func selectScenario(_ scenario: Scenario) {
        selectedScenario = scenario
        isShowingPreview = true
    }

    func dismissPreview() {
        isShowingPreview = false
        selectedScenario = nil
    }

    func markCompleted(_ scenario: Scenario) {
        for mi in modules.indices {
            for si in modules[mi].scenarios.indices {
                if modules[mi].scenarios[si].id == scenario.id {
                    modules[mi].scenarios[si].isCompleted = true
                }
            }
        }
    }
}
