//
//  ImmersiveView.swift
//  AVP-Hackathon-2026
//
//  Created by Carson Hizkia on 23/06/2026.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @Environment(EncounterSession.self) private var session

    @State private var visitor = Entity()
    @State private var torso = ModelEntity()
    @State private var head = ModelEntity()
    @State private var animationTask: Task<Void, Never>?
    @State private var hasAppliedEscalatedAppearance = false

    // Placeholder figure: no rig, just primitives. visionOS places the immersive
    // space's Y=0 at floor level (not eye level), so the visitor's feet sit at
    // y=0 directly — swap for a floor-anchored real avatar later.
    private let conversationPosition: SIMD3<Float> = [0, 0, -1.4]

    var body: some View {
        RealityView { content, attachments in
            // Existing room/skybox content. `content` is `inout`, so it can't be
            // captured by the async Task — add a container synchronously instead
            // and populate it once the scene finishes loading.
            let roomContainer = Entity()
            content.add(roomContainer)
            Task {
                if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                    roomContainer.addChild(immersiveContentEntity)
                }
            }

            // Front desk visitor — placeholder figure, no rig.
            torso = ModelEntity(
                mesh: .generateCylinder(height: 1.0, radius: 0.2),
                materials: [SimpleMaterial(color: .init(red: 0.25, green: 0.32, blue: 0.45, alpha: 1), isMetallic: false)]
            )
            torso.position = [0, 0.5, 0]

            head = ModelEntity(
                mesh: .generateSphere(radius: 0.13),
                materials: [SimpleMaterial(color: .init(red: 0.85, green: 0.7, blue: 0.6, alpha: 1), isMetallic: false)]
            )
            head.position = [0, 1.15, 0]

            visitor.addChild(torso)
            visitor.addChild(head)
            visitor.position = conversationPosition
            visitor.scale = [0.01, 0.01, 0.01]
            content.add(visitor)

            // Timer rides directly above his head — unmissable, reads as "his time is running out."
            if let timer = attachments.entity(for: "timer") {
                timer.position = [0, 1.75, 0]
                visitor.addChild(timer)
            }

            // Response panel sits beside him, not behind, so picking an answer
            // never means looking away from him.
            if let panel = attachments.entity(for: "panel") {
                panel.position = [0.75, 1.1, 0.1]
                visitor.addChild(panel)
            }

            animationTask = Task {
                await popInThenIdle()
                session.startEncounterCountdown()
            }
        } update: { _, _ in
            if session.isEscalating && !hasAppliedEscalatedAppearance {
                hasAppliedEscalatedAppearance = true
                applyEscalatedAppearance()
            }
        } attachments: {
            Attachment(id: "timer") {
                TimerBadge()
            }
            Attachment(id: "panel") {
                EncounterPanel()
            }
        }
        .onDisappear {
            animationTask?.cancel()
        }
    }

    private func popInThenIdle() async {
        visitor.move(
            to: Transform(scale: [1, 1, 1], translation: conversationPosition),
            relativeTo: visitor.parent,
            duration: 0.35,
            timingFunction: .easeOut
        )
        try? await Task.sleep(for: .seconds(0.35))
        guard !Task.isCancelled else { return }
        await idleBob()
    }

    private func idleBob() async {
        let baseY = conversationPosition.y
        var t: Double = 0
        while !Task.isCancelled && !session.isEscalating {
            t += 0.05
            visitor.position.y = baseY + Float(sin(t * 1.5) * 0.015)
            try? await Task.sleep(for: .seconds(0.05))
        }
        if session.isEscalating {
            await agitatedShake()
        }
    }

    private func agitatedShake() async {
        var t: Double = 0
        while !Task.isCancelled {
            t += 0.05
            visitor.transform.rotation = simd_quatf(angle: Float(sin(t * 10) * 0.05), axis: [0, 1, 0])
            try? await Task.sleep(for: .seconds(0.05))
        }
    }

    private func applyEscalatedAppearance() {
        torso.model?.materials = [SimpleMaterial(color: .init(red: 0.55, green: 0.15, blue: 0.15, alpha: 1), isMetallic: false)]
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
        .environment(EncounterSession())
}
