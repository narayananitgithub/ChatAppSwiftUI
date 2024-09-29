//
//  ChatViewModel.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var newMessageContent: String = ""
// MARK: - init
    init() {
        fetchMessages()
    }
    // MARK: - fetchMessages
    func fetchMessages() {
        do {
            self.messages = try DatabaseManager.shared.fetchMessages()
        } catch {
            print("Failed to fetch messages: \(error)")
        }
    }
// MARK: - sendMessage
    func sendMessage(content: String, userId: String) {
        guard !content.isEmpty else { return }
        let sentMessage = Message(id: UUID().uuidString, content: content, timestamp: Date(), userId: userId)
        do {
            try DatabaseManager.shared.saveMessage(message: sentMessage)
            messages.append(sentMessage)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.receiveAutoReply(for: content)
            }
        } catch {
            print("Failed to save message: \(error)")
        }
    }
// MARK: - receiveAutoReply
    private func receiveAutoReply(for content: String) {
        let autoReplyContent = "Received: \(content)"
        let replyMessage = Message(id: UUID().uuidString, content: autoReplyContent, timestamp: Date(), userId: "bot")
        messages.append(replyMessage)
        do {
            try DatabaseManager.shared.saveMessage(message: replyMessage)
        } catch {
            print("Failed to save auto-reply message: \(error)")
        }
    }
}
