import SwiftUI

struct TimerBadge: View {
    @Environment(EncounterSession.self) private var session

    var body: some View {
        ZStack {
            Circle()
                .stroke(.white.opacity(0.25), lineWidth: 6)
            Circle()
                .trim(from: 0, to: session.timeRemaining / session.decisionSeconds)
                .stroke(ringColor, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
            Text("\(Int(ceil(session.timeRemaining)))")
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
        }
        .frame(width: 64, height: 64)
        .padding(14)
        .background(.ultraThinMaterial)
        .clipShape(Circle())
        .opacity(session.encounterPhase == .question ? 1 : 0)
    }

    private var ringColor: Color {
        let fraction = session.timeRemaining / session.decisionSeconds
        if fraction > 0.5 { return .green }
        if fraction > 0.2 { return .orange }
        return .red
    }
}

#Preview {
    TimerBadge()
        .environment(EncounterSession())
}
