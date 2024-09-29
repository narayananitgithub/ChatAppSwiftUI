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
    private let name = Expression<String>("name")
// MARK: - init
    private init() {
        do {
            let fileURL = try FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first!
                .appendingPathComponent("chatApp.sqlite")
            db = try Connection(fileURL.path)
            print("Database path: \(fileURL.path)")
            try createTables()
            loadMockData()
        } catch {
            print("Error initializing database: \(error)")
        }
    }
    // MARK: - createTables
    private func createTables() throws {
        try db.run(usersTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(name)
        })
        try db.run(messagesTable.create(ifNotExists: true) { t in
            t.column(id, primaryKey: true)
            t.column(content)
            t.column(timestamp)
            t.column(userId)
        })
    }
    // MARK: - clearDatabase
    func clearDatabase() throws {
        try db.run(messagesTable.delete())
        try db.run(usersTable.delete())
    }
// MARK: - fetchUsers
    func fetchUsers() throws -> [User] {
        var users: [User] = []
        for user in try db.prepare(usersTable) {
            users.append(User(id: user[id], name: user[name]))
        }
        return users
    }
// MARK: - loadMockData
    private func loadMockData() {
        guard let url = Bundle.main.url(forResource: "mockData", withExtension: "json") else {
            print("Could not find mockData.json")
            return
        }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let chatData = try decoder.decode(ChatData.self, from: data)
            for user in chatData.users {
                if try fetchUsers().first(where: { $0.id == user.id }) == nil {
                    try saveUser(user: user)
                }
            }
            for message in chatData.messages {
                if try fetchMessages().first(where: { $0.id == message.id }) == nil {
                    let messageWithUniqueID = Message(id: UUID().uuidString, content: message.content, timestamp: message.timestamp, userId: message.userId)
                    try saveMessage(message: messageWithUniqueID)
                } else {
                    print("Message with ID \(message.id) already exists in the database. Skipping.")
                }
            }
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
// MARK: - fetchMessages
    func fetchMessages() throws -> [Message] {
        var messages: [Message] = []
        for message in try db.prepare(messagesTable) {
            messages.append(Message(id: message[id], content: message[content], timestamp: message[timestamp], userId: message[userId]))
        }
        return messages
    }
    // MARK: - saveMessage
    func saveMessage(message: Message) throws {
        let insert = messagesTable.insert(id <- message.id, content <- message.content, timestamp <- message.timestamp, userId <- message.userId)
        try db.run(insert)
    }
    // MARK: - saveUser
    func saveUser(user: User) throws {
        let insert = usersTable.insert(id <- user.id, name <- user.name) // Assuming 'name' is a property of User
        try db.run(insert)
    }
}
