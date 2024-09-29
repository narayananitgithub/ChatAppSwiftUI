//
//  MessageViewModel.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation
import Combine

class MessageViewModel: ObservableObject {
    // MARK: - properties
    @Published var messages: [Message] = []
    private let usersViewModel: ChatViewModel
    
    init(usersViewModel: ChatViewModel) {
        self.usersViewModel = usersViewModel
        fetchMessages()
    }
    // MARK: - fetchMessages
    func fetchMessages() {
        usersViewModel.fetchMessages()
    }
    // MARK: - sendMessage
    func sendMessage(userId: String, content: String) {
        usersViewModel.sendMessage(content: content, userId: userId)
    }
}
