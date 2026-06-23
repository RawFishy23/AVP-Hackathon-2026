import SwiftUI

struct ResultsView: View {
    @Environment(EncounterSession.self) private var session
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    private var outcome: EncounterSession.Outcome { session.outcome }

    var body: some View {
        VStack(spacing: 32) {
            Text("Overview of Training")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.white)

            icon

            Text(narrative)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(8)
                .fixedSize(horizontal: false, vertical: true)

            pageDots

            buttons
        }
        .padding(56)
        .frame(maxWidth: 900)
        .background(Color(red: 190 / 255, green: 180 / 255, blue: 171 / 255).opacity(0.6))
        .clipShape(RoundedRectangle(cornerRadius: 60))
        .padding(60)
        .navigationTitle("Results")
        .task {
            await dismissImmersiveSpace()
        }
    }

    @ViewBuilder
    private var icon: some View {
        switch outcome {
        case .correct:
            Image("ResultPass")
                .resizable()
                .frame(width: 100, height: 100)
        case .wrong:
            Image("ResultFail")
                .resizable()
                .frame(width: 100, height: 100)
        case .needsImprovement:
            Image(systemName: "exclamationmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.orange)
        }
    }

    private var narrative: String {
        switch outcome {
        case .correct:
            return "Congratulations, you completed the module.\n\nYou maintained patient confidentiality, recognised the visitor's escalating behaviour, and called Code Black without hesitation — security responded in \(String(format: "%.1f", session.codeBlackResponseSeconds))s."
        case .needsImprovement:
            return "You got there, but it took \(session.incorrectAttempts) wrong attempt\(session.incorrectAttempts == 1 ? "" : "s") before giving the correct response.\n\nReview when it's appropriate to neither confirm nor deny a patient's presence, then call Code Black as soon as a visitor becomes a safety risk."
        case .wrong:
            if session.timedOut {
                return "You ran out of time to respond, and the visitor's behaviour escalated before you acted.\n\nUnder pressure, default to \"I cannot confirm nor deny if this patient is here\" — then call Code Black the moment things escalate."
            }
            return "Code Black was not activated for this encounter.\n\nWhen a visitor becomes aggressive or violent, escalate immediately by calling Code Black so security can respond."
        }
    }

    private var pageDots: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(.white.opacity(index == 0 ? 1 : 0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }

    @ViewBuilder
    private var buttons: some View {
        switch outcome {
        case .correct:
            Button {
                session.resetFlow()
            } label: {
                Text("Next")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.healthBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .buttonStyle(.plain)
            .hoverEffect()
        case .needsImprovement, .wrong:
            HStack(spacing: 16) {
                Button {
                    session.retryFlow()
                } label: {
                    Text("Back")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color(white: 0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
                .hoverEffect()

                Button {
                    session.resetFlow()
                } label: {
                    Text("Finish")
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
    }
}

#Preview(windowStyle: .automatic) {
    NavigationStack {
        ResultsView()
    }
    .environment(EncounterSession())
}
