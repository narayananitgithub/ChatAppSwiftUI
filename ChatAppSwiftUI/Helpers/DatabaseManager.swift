//
//  DatabaseManager.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SQLite
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private var db: Connection!
    private let usersTable = Table("users")
    private let messagesTable = Table("messages")
    
    private let id = Expression<String>("id")
    private let content = Expression<String>("content")
    private let timestamp = Expression<Date>("timestamp")
    private let userId = Expression<String>("userId")
    private let name = Expression<String>("name") // Define the 'name' column



    private init() {
        do {
            // Database connection setup
            let fileURL = try FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("chatApp.sqlite")
            
            db = try Connection(fileURL.path)
            
            // Print only the database file URL
            print("Database file URL: \(fileURL)") // Print the database file URL
            
            try createTables()
            
            // Load mock data
            loadMockData()
        } catch {
            print("Error initializing database: \(error)")
        }
    }

    private func createTables() throws {
        try db.run(usersTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)   // User ID
            t.column(name)                   // Name of the user
        })
        
        try db.run(messagesTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)    // Message ID
            t.column(content)                 // Content of the message
            t.column(timestamp)               // Timestamp of the message
            t.column(userId)                  // User ID for the message
        })
    }
    
    func clearDatabase() throws {
        try db.run(messagesTable.delete())
        try db.run(usersTable.delete())
    }
    func fetchUsers() throws -> [User] {
        var users: [User] = []
        for user in try db.prepare(usersTable) {
            users.append(User(id: user[id], name: user[name])) // Accessing name from the user record
        }
        return users
    }

    private func loadMockData() {
        guard let url = Bundle.main.url(forResource: "mockData", withExtension: "json") else {
            print("Could not find mockData.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601 // Handle ISO8601 date format
            let chatData = try decoder.decode(ChatData.self, from: data)
            
            // Save users to SQLite
            for user in chatData.users {
                // Check if the user already exists
                if try fetchUsers().first(where: { $0.id == user.id }) == nil {
                    try saveUser(user: user)
                }
            }

            // Save messages to SQLite with unique IDs
            for message in chatData.messages {
                // Check if the message ID already exists
                if try fetchMessages().first(where: { $0.id == message.id }) == nil {
                    let messageWithUniqueID = Message(id: UUID().uuidString, content: message.content, timestamp: message.timestamp, userId: message.userId)
                    try saveMessage(message: messageWithUniqueID)
                } else {
                    print("Message with ID \(message.id) already exists in the database. Skipping.")
                }
            }
            
            // Print loaded messages with details
            let loadedMessages = try fetchMessages()
            print("Loaded Messages:")
            for message in loadedMessages {
                print("ID: \(message.id), Content: \(message.content), Timestamp: \(message.timestamp), User ID: \(message.userId)")
            }
        } catch let decodingError {
            print("Failed to load mock data: \(decodingError)")
        } catch {
            print("Database error: \(error)")
        }
    }

    func fetchMessages() throws -> [Message] {
        var messages: [Message] = []
        for message in try db.prepare(messagesTable) {
            messages.append(Message(id: message[id], content: message[content], timestamp: message[timestamp], userId: message[userId]))
        }
        return messages
    }
    
    func saveMessage(message: Message) throws {
        let insert = messagesTable.insert(id <- message.id, content <- message.content, timestamp <- message.timestamp, userId <- message.userId)
        try db.run(insert)
    }
    
    func saveUser(user: User) throws {
        let insert = usersTable.insert(id <- user.id, name <- user.name) // Assuming 'name' is a property of User
        try db.run(insert)
    }
}
