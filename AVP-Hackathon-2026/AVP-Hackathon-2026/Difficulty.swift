//
//  Difficulty.swift
//  AVP-Hackathon-2026
//
//  Created by Carson Hizkia on 23/06/2026.
//


//
//  TrainingData.swift
//  AVP-Hackathon-2026
//
//  ── EDIT HERE ──────────────────────────────────────────────────────────────
//  All modules and scenarios are defined in this file.
//  To add a module: append a new `TrainingModule` to `TrainingData.all`.
//  To add a scenario: append a new `Scenario` to a module's `scenarios` array.
//  ───────────────────────────────────────────────────────────────────────────

import SwiftUI

// MARK: - Difficulty

enum Difficulty: String, CaseIterable {
    case beginner    = "Beginner"
    case intermediate = "Intermediate"
    case advanced    = "Advanced"

    var color: Color {
        switch self {
        case .beginner:     return .green
        case .intermediate: return .orange
        case .advanced:     return .red
        }
    }
    var systemImage: String {
        switch self {
        case .beginner:     return "1.circle.fill"
        case .intermediate: return "2.circle.fill"
        case .advanced:     return "3.circle.fill"
        }
    }
}

// MARK: - Scenario

struct Scenario: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String          // Short blurb shown on the card
    let detailDescription: String    // Full text shown on the preview page
    let duration: String             // e.g. "8 min"
    let difficulty: Difficulty
    let category: String             // e.g. "Cardiac", "Trauma"
    let thumbnailSystemImage: String // SF Symbol used as placeholder thumbnail
    let videoName: String?           // Name of video asset in bundle (nil = no video yet)
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        detailDescription: String,
        duration: String,
        difficulty: Difficulty,
        category: String,
        thumbnailSystemImage: String = "play.rectangle.fill",
        videoName: String? = nil,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.detailDescription = detailDescription
        self.duration = duration
        self.difficulty = difficulty
        self.category = category
        self.thumbnailSystemImage = thumbnailSystemImage
        self.videoName = videoName
        self.isCompleted = isCompleted
    }
}

// MARK: - Module

struct TrainingModule: Identifiable, Hashable {
    let id: UUID
    let title: String
    let subtitle: String
    let systemImage: String
    var scenarios: [Scenario]
    let accentColor: Color

    var completionFraction: Double {
        guard !scenarios.isEmpty else { return 0 }
        return Double(scenarios.filter(\.isCompleted).count) / Double(scenarios.count)
    }

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String,
        systemImage: String,
        scenarios: [Scenario],
        accentColor: Color = .blue
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.scenarios = scenarios
        self.accentColor = accentColor
    }
}

// MARK: - Content (EDIT THIS)

enum TrainingData {
    static var all: [TrainingModule] = [
        TrainingModule(
            title: "Safety & Clinical Rules",
            subtitle: "Policies, protocols & safe clinical practice",
            systemImage: "shield.checkered",
            scenarios: [
                Scenario(
                    title: "Hand Hygiene",
                    description: "Perform effective hand hygiene using the correct technique.",
                    detailDescription: "Practise the WHO 5 Moments for Hand Hygiene and demonstrate proper hand washing and alcohol-based hand rub techniques to reduce healthcare-associated infections. Identify common mistakes and ensure compliance with infection prevention standards.",
                    duration: "5 min",
                    difficulty: .beginner,
                    category: "Infection Control",
                    thumbnailSystemImage: "hands.sparkles.fill"
                ),

                Scenario(
                    title: "PPE Use",
                    description: "Correctly don and doff personal protective equipment.",
                    detailDescription: "Learn the proper sequence for putting on and removing gloves, gowns, masks, and eye protection. Prevent self-contamination while managing patients requiring standard, contact, droplet, or airborne precautions.",
                    duration: "8 min",
                    difficulty: .intermediate,
                    category: "Infection Control",
                    thumbnailSystemImage: "facemask.fill"
                ),

                Scenario(
                    title: "Managing Infectious Diseases",
                    description: "Recognise and manage patients with infectious conditions safely.",
                    detailDescription: "Assess patients presenting with suspected infectious diseases, implement appropriate isolation precautions, select suitable PPE, and coordinate care while minimising transmission risks to staff and other patients.",
                    duration: "15 min",
                    difficulty: .advanced,
                    category: "Infection Control",
                    thumbnailSystemImage: "cross.case.fill"
                )
            ],
            accentColor: .blue
        ),

        TrainingModule(
            title: "Conflict Management",
            subtitle: "De-escalation, communication & dispute resolution",
            systemImage: "person.2.fill",
            scenarios: [
                Scenario(
                    title: "Managing Aggression",
                    description: "Safely assess and de-escalate an aggressive patient.",
                    detailDescription: "A patient in the emergency department becomes increasingly agitated and verbally aggressive toward staff. Use verbal de-escalation techniques, identify triggers, maintain personal safety, and escalate appropriately when required while preserving patient dignity and therapeutic rapport.",
                    duration: "12 min",
                    difficulty: .advanced,
                    category: "Behavioural Management",
                    thumbnailSystemImage: "exclamationmark.bubble.fill"
                ),

                Scenario(
                    title: "Conflict Resolution",
                    description: "Resolve workplace conflict through effective communication.",
                    detailDescription: "Navigate a disagreement between healthcare team members during a busy shift. Practise active listening, identify underlying concerns, manage emotions professionally, and work toward a collaborative resolution that maintains patient safety and team cohesion.",
                    duration: "10 min",
                    difficulty: .intermediate,
                    category: "Communication",
                    thumbnailSystemImage: "person.2.fill"
                )
            ],
            accentColor: .blue
        ),

        TrainingModule(
            title: "Mental Health Awareness",
            subtitle: "RSI, difficult airways & rescue",
            systemImage: "brain.filled.head.profile",
            scenarios: [
                Scenario(
                    title: "Rapid Sequence Intubation",
                    description: "Perform RSI safely in a compromised airway.",
                    detailDescription: "A GCS 9 patient with facial burns requires definitive airway management. Pre-oxygenate, choose appropriate agents, perform laryngoscopy, and confirm placement while managing a potential haemodynamic collapse.",
                    duration: "10 min",
                    difficulty: .intermediate,
                    category: "Airway",
                    thumbnailSystemImage: "medical.thermometer"
                ),
                Scenario(
                    title: "Can't Intubate, Can't Oxygenate",
                    description: "Navigate a CICO emergency with surgical airway rescue.",
                    detailDescription: "After failed intubation and supraglottic airway insertion, SpO₂ continues to fall. Declare CICO, perform a scalpel-finger-bougie cricothyroidotomy, and transition to definitive airway management.",
                    duration: "6 min",
                    difficulty: .advanced,
                    category: "Airway",
                    thumbnailSystemImage: "exclamationmark.triangle.fill"
                )
            ],
            accentColor: .blue
        ),

        TrainingModule(
            title: "Professional Ethics and Duty of Care",
            subtitle: "Neonates, infants & children",
            systemImage: "figure.child",
            scenarios: [
                Scenario(
                    title: "Febrile Seizure",
                    description: "Assess and manage a 2-year-old in prolonged seizure.",
                    detailDescription: "A 2-year-old is brought in by ambulance, still seizing after 8 minutes. Calculate weight-based benzodiazepine dosing, establish IV/IO access, and manage the post-ictal child with fever workup.",
                    duration: "12 min",
                    difficulty: .beginner,
                    category: "Paediatrics",
                    thumbnailSystemImage: "figure.child.circle"
                )
            ],
            accentColor: .blue
        )
    ]
}
