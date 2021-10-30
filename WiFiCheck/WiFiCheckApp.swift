//
//  WiFiCheckApp.swift
//  WiFiCheck
//
//  Created by Eric Wuehler on 9/10/21.
//

import SwiftUI

@main
struct WiFiCheckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().frame(minWidth: 600)
        }.commands {
            SidebarCommands()
        }
    }
}

struct WiFiButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(0)
            .font(.subheadline)
            .background(Color.accentColor)
            .clipShape(Capsule())
    }
}

