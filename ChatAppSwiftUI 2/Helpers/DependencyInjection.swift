//
//  DependencyInjection.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Foundation

class DependencyInjection {
    static let shared = DependencyInjection()
    private init() {}
    lazy var apiManager: WebserviceManager = {
        return WebserviceManager()
    }()
    // MARK: - userViewModel
    func userViewModel() -> ChatViewModel {
        return ChatViewModel() // Corrected to use the default initializer
    }
    // MARK: - messageViewModel
    func messageViewModel() -> MessageViewModel {
        return MessageViewModel(usersViewModel: userViewModel()) // Pass the UsersViewModel instance
    }
}

