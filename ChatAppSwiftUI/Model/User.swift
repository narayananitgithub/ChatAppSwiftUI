//
//  User.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation
// MARK: - UserModel

struct User: Identifiable, Codable {
    let id: String
    let name: String  // Ensure this matches the database schema
}
