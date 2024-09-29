//
//  MessageViewModel.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation
import Combine

class MessageViewModel {
    private let chatViewModel: ChatViewModel

    init(chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
    }

    func sendMessage(userId: String, content: String) {
        chatViewModel.sendMessage(content: content, userId: userId) // No error here now
    }
}
