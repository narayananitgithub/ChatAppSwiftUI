//
//  WebserviceManager.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//


import Alamofire


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
    // MARK: - init
    init() {
        loadMockData()
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
                if try DatabaseManager.shared.fetchUsers().first(where: { $0.id == user.id }) == nil {
                    try DatabaseManager.shared.saveUser(user: user)
                }
            }
            for message in chatData.messages {
                if try DatabaseManager.shared.fetchMessages().first(where: { $0.id == message.id }) == nil {
                    var messageWithUniqueID = message
                    messageWithUniqueID.id = UUID().uuidString
                    try DatabaseManager.shared.saveMessage(message: messageWithUniqueID)
                } else {
                    print("Message with ID \(message.id) already exists in the database. Skipping.")
                }
            }
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
    // MARK: - performRequest
    func performRequest<T: Decodable>(url: URLType, method: HTTPMethod, parameters: Parameters? = nil, completion: @escaping (Result<T, APIError>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) { // Simulate network delay
            switch url {
            case .messages:
                if method == .get {
                    // Simulate fetching messages
                    if let messages = self.storedMessages as? T {
                        completion(.success(messages))
                    } else {
                        completion(.failure(.nilData))
                    }
                } else if method == .post, let params = parameters, let message = self.parseMessage(from: params) {
                    // Simulate sending a message
                    self.storedMessages.append(message)
                    if let message = message as? T {
                        completion(.success(message))
                    } else {
                        completion(.failure(.nilData))
                    }
                } else {
                    completion(.failure(.invalidURL))
                }
            default:
                completion(.failure(.invalidURL))
            }
        }
    }
    // MARK: - parseMessage
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

