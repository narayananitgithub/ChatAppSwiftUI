//
//  ChatAppSwiftUIApp.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SwiftUI

@main
struct ChatApp: App {
    let dependencyInjection = DependencyInjection()

    var body: some Scene {
        WindowGroup {
            ContentView() // Use ContentView here, which has the EnvironmentObject
                .environmentObject(dependencyInjection.chatViewModel()) // Set the environment object for the entire app
        }
    }
}
