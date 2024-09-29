//
//  Message.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation
// MARK: - Message
struct Message: Identifiable, Codable,Equatable {
    var id: String 
    var content: String
    var timestamp: Date
    var userId: String
}
// MARK: - ChatData
struct ChatData: Codable {
    let users: [User]
    let messages: [Message]
}
