//
//  HomeView.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel: ChatViewModel

    init() {
        let di = DependencyInjection()
        _viewModel = StateObject(wrappedValue: di.chatViewModel()) // Use DI to get the view model
    }

    var body: some View {
        ChatView()
            .environmentObject(viewModel) // Set the view model as an environment object
    }
}
