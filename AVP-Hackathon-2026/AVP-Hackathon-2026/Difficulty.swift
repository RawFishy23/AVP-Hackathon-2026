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
    let encounterID: String?         // Identifies a scenario with a built immersive encounter (nil = not implemented yet)

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
        isCompleted: Bool = false,
        encounterID: String? = nil
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
        self.encounterID = encounterID
    }
}

// MARK: - Encounter IDs

enum EncounterID {
    static let frontDeskPrivacy = "frontDeskPrivacy"
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
            title: "Cardiac Emergencies",
            subtitle: "Arrhythmias, MI & CPR",
            systemImage: "heart.fill",
            scenarios: [
                Scenario(
                    title: "Ventricular Fibrillation",
                    description: "Recognise and treat a patient in VF arrest.",
                    detailDescription: "A 58-year-old male collapses in the ED waiting room. Monitors show coarse VF. Practise rapid rhythm recognition, safe defibrillation technique, and post-ROSC care in this high-fidelity simulation.",
                    duration: "12 min",
                    difficulty: .intermediate,
                    category: "Cardiac",
                    thumbnailSystemImage: "waveform.path.ecg"
                ),
                Scenario(
                    title: "STEMI Recognition",
                    description: "12-lead ECG interpretation and rapid cath-lab activation.",
                    detailDescription: "Review a series of 12-lead ECGs presenting with anterior, inferior, and lateral STEMI patterns. Make the call to activate the cath lab and manage concurrent therapies in under 10 minutes from door-to-balloon.",
                    duration: "10 min",
                    difficulty: .beginner,
                    category: "Cardiac",
                    thumbnailSystemImage: "heart.text.square"
                ),
                Scenario(
                    title: "Acute Heart Failure",
                    description: "Manage flash pulmonary oedema in a deteriorating patient.",
                    detailDescription: "A 72-year-old female presents with acute dyspnoea, diaphoresis, and SpO₂ of 82%. Use non-invasive ventilation, vasodilators, and diuresis in this time-pressured scenario.",
                    duration: "15 min",
                    difficulty: .advanced,
                    category: "Cardiac",
                    thumbnailSystemImage: "lungs.fill"
                )
            ],
            accentColor: .red
        ),

        TrainingModule(
            title: "Trauma & Resuscitation",
            subtitle: "Haemorrhage control & ATLS",
            systemImage: "staroflife.fill",
            scenarios: [
                Scenario(
                    title: "Massive Haemorrhage",
                    description: "Activate the MHP and manage haemorrhagic shock.",
                    detailDescription: "A polytrauma patient arrives by air retrieval with a suspected pelvic fracture and falling BP. Initiate the massive haemorrhage protocol, request balanced blood products, and coordinate with theatre in this team-based simulation.",
                    duration: "18 min",
                    difficulty: .advanced,
                    category: "Trauma",
                    thumbnailSystemImage: "cross.case.fill"
                ),
                Scenario(
                    title: "Tension Pneumothorax",
                    description: "Identify and immediately decompress a tension PTX.",
                    detailDescription: "Following blunt chest trauma, your patient acutely deteriorates. Absent breath sounds and tracheal deviation — recognise the diagnosis and perform needle decompression before inserting a chest drain.",
                    duration: "8 min",
                    difficulty: .intermediate,
                    category: "Trauma",
                    thumbnailSystemImage: "lungs"
                )
            ],
            accentColor: .orange
        ),

        TrainingModule(
            title: "Airway Management",
            subtitle: "RSI, difficult airways & rescue",
            systemImage: "mouth.fill",
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
            title: "Paediatric Emergencies",
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
            accentColor: .purple
        ),

        TrainingModule(
            title: "Front Desk & Security",
            subtitle: "Patient privacy & Code Black",
            systemImage: "shield.lefthalf.filled",
            scenarios: [
                Scenario(
                    title: "Patient Privacy at the Front Desk",
                    description: "A visitor presses you for a patient's room — then escalates.",
                    detailDescription: "A visitor approaches your desk asking for a patient's room number. Protect patient confidentiality while staying calm and professional — even if the visitor's behaviour escalates and you need to call a Code Black.",
                    duration: "5 min",
                    difficulty: .beginner,
                    category: "Patient Privacy",
                    thumbnailSystemImage: "person.fill.questionmark",
                    encounterID: EncounterID.frontDeskPrivacy
                )
            ],
            accentColor: .blue
        )
    ]
}