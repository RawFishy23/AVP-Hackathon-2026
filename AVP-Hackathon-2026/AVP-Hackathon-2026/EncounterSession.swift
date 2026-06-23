import SwiftUI
import Observation

// MARK: - Navigation

/// Pushed onto the detail column's NavigationStack once an immersive
/// encounter resolves — separate from AppModel's scenario-preview selection.
enum EncounterRoute: Hashable {
    case codeBlack
    case results
}

enum EncounterPhase {
    case question, wrongFeedback, escalation
}

// MARK: - Shared Encounter State

/// Tracks one in-progress front-desk encounter. Shared (via environment)
/// between the window's CodeBlack/Results screens and the RealityKit
/// attachments floating next to the visitor in the immersive space.
@Observable
final class EncounterSession {
    var correctResponseChosen = false
    var incorrectAttempts = 0
    var timedOut = false
    var codeBlackCalled = false
    var codeBlackResponseSeconds: Double = 0
    var isEscalating = false

    var advanceToCodeBlack: () -> Void = {}
    var resetFlow: () -> Void = {}
    var retryFlow: () -> Void = {}

    // Encounter timer/phase — shared so the timer badge (above the visitor's
    // head) and the response panel (beside him) can be separate attachments
    // that stay in sync instead of one combined view.
    let decisionSeconds: Double = 12
    let bufferSeconds: Double = 4
    var encounterPhase: EncounterPhase = .question
    var timeRemaining: Double = 12
    var lastWrongIndex: Int?
    private var countdownTask: Task<Void, Never>?

    func startEncounterCountdown() {
        countdownTask?.cancel()
        countdownTask = Task {
            try? await Task.sleep(for: .seconds(bufferSeconds))
            guard !Task.isCancelled, encounterPhase == .question else { return }
            while timeRemaining > 0 && encounterPhase == .question {
                try? await Task.sleep(for: .seconds(0.1))
                guard !Task.isCancelled else { return }
                timeRemaining = max(0, timeRemaining - 0.1)
            }
            if timeRemaining <= 0 && encounterPhase == .question {
                timedOut = true
                encounterPhase = .escalation
                isEscalating = true
            }
        }
    }

    func selectResponse(_ index: Int, correctIndex: Int) {
        lastWrongIndex = nil
        if index == correctIndex {
            correctResponseChosen = true
            countdownTask?.cancel()
            encounterPhase = .escalation
            isEscalating = true
        } else {
            incorrectAttempts += 1
            lastWrongIndex = index
            encounterPhase = .wrongFeedback
        }
    }

    func reset() {
        correctResponseChosen = false
        incorrectAttempts = 0
        timedOut = false
        codeBlackCalled = false
        codeBlackResponseSeconds = 0
        isEscalating = false
        encounterPhase = .question
        timeRemaining = decisionSeconds
        lastWrongIndex = nil
        countdownTask?.cancel()
    }

    enum Outcome {
        case correct, needsImprovement, wrong

        var iconAssetName: String? {
            switch self {
            case .correct: return "ResultPass"
            case .wrong: return "ResultFail"
            case .needsImprovement: return nil
            }
        }
    }

    var outcome: Outcome {
        if timedOut || !correctResponseChosen || !codeBlackCalled { return .wrong }
        if incorrectAttempts > 0 { return .needsImprovement }
        return .correct
    }
}

// MARK: - Brand Colour

extension Color {
    static let healthBlue = Color(red: 0 / 255, green: 145 / 255, blue: 255 / 255)
}

extension ShapeStyle where Self == Color {
    static var healthBlue: Color { Color.healthBlue }
}
