//
//  Message.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation

struct Message:  Codable,Identifiable {
    var id: String // Change this from 'let' to 'var'
    var content: String
    var timestamp: Date
    var userId: String
}
struct ChatData: Codable {
    let users: [User]
    let messages: [Message]
}
