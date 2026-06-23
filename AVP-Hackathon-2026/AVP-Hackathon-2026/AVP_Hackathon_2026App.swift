//
//  AVP_Hackathon_2026App.swift
//  AVP-Hackathon-2026
//
//  Created by Carson Hizkia on 23/06/2026.
//

import SwiftUI

@main
struct AVP_Hackathon_2026App: App {

    @State private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }

        ImmersiveSpace(id: appModel.immersiveSpaceID) {
            ImmersiveView()
                .environment(appModel)
                .onAppear {
                    appModel.immersiveSpaceState = .open
                }
                .onDisappear {
                    appModel.immersiveSpaceState = .closed
                }
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
     }
}
