import SwiftUI

struct EncounterPanel: View {
    @Environment(EncounterSession.self) private var session

    private let choices = [
        "Let me check our patient records for you.",
        "I cannot confirm nor deny if this patient is here.",
        "He's in room 204, just down the hall.",
        "I'm not allowed to say, but try calling his cell phone."
    ]
    private let correctIndex = 1

    var body: some View {
        VStack(spacing: 0) {
            Text(session.encounterPhase == .escalation ? "THE VISITOR IS ESCALATING" : "FRONT DESK ENCOUNTER")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.healthBlue)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 14)

            if session.encounterPhase == .escalation {
                escalationContent
            } else {
                menuContent
            }
        }
        .padding(20)
        .frame(width: 380)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .strokeBorder(session.encounterPhase == .escalation ? Color.red.opacity(0.5) : Color.white.opacity(0.4), lineWidth: 1.4)
        )
    }

    private var menuContent: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Text("What is your response?")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                Text("\"Hi, I'm looking for my friend John Smith. Can you tell me what room he's in and how he's doing?\"")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, 16)

            ForEach(choices.indices, id: \.self) { index in
                MenuItemRow(
                    text: choices[index],
                    isWrong: session.encounterPhase == .wrongFeedback && session.lastWrongIndex == index
                ) {
                    session.selectResponse(index, correctIndex: correctIndex)
                }
                if index < choices.count - 1 {
                    Divider().background(.white.opacity(0.12))
                }
            }

            if session.encounterPhase == .wrongFeedback {
                Text("That discloses protected patient information. The correct response is to neither confirm nor deny a patient's presence.")
                    .font(.system(size: 13))
                    .foregroundStyle(.orange)
                    .padding(.top, 12)
            }
        }
    }

    private var escalationContent: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("\"You HAVE to tell me! I know he's in this hospital — just tell me his room number, NOW!\"")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)

            Text("The visitor is raising their voice. This requires immediate escalation.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.7))

            Button {
                session.advanceToCodeBlack()
            } label: {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                    Text("Call Code Black")
                        .font(.system(size: 19, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            .hoverEffect()
        }
    }
}

private struct MenuItemRow: View {
    let text: String
    let isWrong: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.vertical, 14)
            .padding(.horizontal, isWrong ? 8 : 0)
            .background(isWrong ? Color.red.opacity(0.25) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .hoverEffect()
    }
}

#Preview {
    EncounterPanel()
        .environment(EncounterSession())
}
