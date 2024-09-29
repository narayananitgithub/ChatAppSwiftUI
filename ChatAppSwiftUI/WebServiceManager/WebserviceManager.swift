//
//  WebserviceManager.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//


import Alamofire
import Combine

// MARK: - API Error Enum
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case badRequest
    case nilData
    case decodingError(Error)
    case customError(String)
    case serverError(String)
}

class WebserviceManager {
    static let shared = WebserviceManager()

    private var storedMessages: [Message] = []

    init() {
        loadMockData()
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
                if try DatabaseManager.shared.fetchUsers().first(where: { $0.id == user.id }) == nil {
                    try DatabaseManager.shared.saveUser(user: user)
                }
            }

            // Save messages to SQLite with unique IDs
            for message in chatData.messages {
                // Check if the message ID already exists
                if try DatabaseManager.shared.fetchMessages().first(where: { $0.id == message.id }) == nil {
                    var messageWithUniqueID = message
                    messageWithUniqueID.id = UUID().uuidString // Generate a new unique ID
                    try DatabaseManager.shared.saveMessage(message: messageWithUniqueID)
                } else {
                    print("Message with ID \(message.id) already exists in the database. Skipping.")
                }
            }

            // Print loaded messages with details
            let loadedMessages = try DatabaseManager.shared.fetchMessages()
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

    func mockRealTimeMessageUpdates() -> AnyPublisher<Message, Never> {
        // Simulating real-time updates with Combine
        let messages = [
            Message(id: UUID().uuidString, content: "Hello!", timestamp: Date(), userId: "2"),
            Message(id: UUID().uuidString, content: "How are you?", timestamp: Date(), userId: "3")
        ]

        // Create a timer that publishes every 5 seconds
        return Timer.publish(every: 5.0, on: .main, in: .common)
            .autoconnect()
            .flatMap { _ in
                Just(messages.randomElement()!) // Pick one message randomly for simulation
            }
            .eraseToAnyPublisher()
    }

    func sendMessage(_ message: Message) {
        // Simulate sending message to server
        print("Message sent to server: \(message.content)")
        storedMessages.append(message) // Add to stored messages
    }

    // Perform API requests to fetch or send messages
    func performRequest<T: Decodable>(url: URLType, method: HTTPMethod, parameters: Parameters? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // Simulate network delay
            switch url {
            case .messages:
                if method == .get {
                    // Simulate fetching messages
                    completion(.success(self.storedMessages as! T)) // Cast to the expected type
                } else if method == .post, let params = parameters, let message = self.parseMessage(from: params) {
                    // Simulate sending a message
                    self.storedMessages.append(message)
                    completion(.success(message as! T)) // Cast to the expected type
                } else {
                    completion(.failure(.invalidURL))
                }
            default:
                completion(.failure(.invalidURL))
            }
        }
    }

    private func parseMessage(from parameters: Parameters) -> Message? {
        guard
            let id = parameters["id"] as? String,
            let userId = parameters["userId"] as? String,
            let content = parameters["content"] as? String,
            let timestampStr = parameters["timestamp"] as? String,
            let timestamp = ISO8601DateFormatter().date(from: timestampStr)
        else {
            return nil
        }
        return Message(id: id, content: content, timestamp: timestamp, userId: userId)
    }
}
