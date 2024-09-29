//
//  ChatAppSwiftUIApp.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SwiftUI

@main
struct YourApp: App {
    @StateObject private var chatViewModel = ChatViewModel() // Create a StateObject

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(chatViewModel) // Pass it as an EnvironmentObject
        }
    }
}
