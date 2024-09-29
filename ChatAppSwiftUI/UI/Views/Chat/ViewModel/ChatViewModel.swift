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

    private let webserviceManager: WebserviceManager
    private let databaseManager: DatabaseManager

    init(webserviceManager: WebserviceManager, databaseManager: DatabaseManager) {
        self.webserviceManager = webserviceManager
        self.databaseManager = databaseManager
        fetchMessages() // Load existing messages upon initialization
    }
    
    // This function simulates sending a message and receiving a reply
    func sendMessage(content: String, userId: String) {
        guard !content.isEmpty else { return }
        
        // Create a message object for the sent message
        let sentMessage = Message(id: UUID().uuidString, content: content, timestamp: Date(), userId: userId)
        messages.append(sentMessage)
        
        // Simulate sending the message through the WebserviceManager
        webserviceManager.sendMessage(sentMessage) // Send the message using WebserviceManager

        // Simulate receiving a response message after a delay (e.g., 1 second)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let responseMessage = Message(id: UUID().uuidString, content: "Received: \(content)", timestamp: Date(), userId: "2")
            self.messages.append(responseMessage)
        }
    }
    
    // Fetch existing messages (optional, for loading previous messages)
    func fetchMessages() {
        // Fetch messages from DatabaseManager or mock data
        messages = [
            Message(id: UUID().uuidString, content: "Hello!", timestamp: Date().addingTimeInterval(-600), userId: "2"),
            Message(id: UUID().uuidString, content: "How are you?", timestamp: Date().addingTimeInterval(-300), userId: "1")
        ]
    }
}
