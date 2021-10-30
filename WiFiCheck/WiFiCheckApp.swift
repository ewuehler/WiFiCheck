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
    var delete: Bool = false
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(EdgeInsets(top:2, leading: 10, bottom: 2, trailing: 10))
            .font(.subheadline)
            .background(delete ? Color.red : Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }
}

