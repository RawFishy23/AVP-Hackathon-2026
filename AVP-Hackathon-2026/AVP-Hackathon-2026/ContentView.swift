//
//  ContentView.swift
//  AVP-Hackathon-2026
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DashboardView()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
