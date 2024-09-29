//
//  HomeView.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Properties
    @EnvironmentObject var chatViewModel: ChatViewModel
    var body: some View {
        ChatView()
            .environmentObject(chatViewModel)
    }
}
// MARK: - HomeView
#Preview {
   HomeView()
}
