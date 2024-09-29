//
//  DependencyInjection.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import Swinject

class DependencyInjection {
    let container: Container

    init() {
        container = Container()
        setupDependencies()
    }

    private func setupDependencies() {
        // Register dependencies
        container.register(WebserviceManager.self) { _ in WebserviceManager.shared }
        container.register(DatabaseManager.self) { _ in DatabaseManager.shared }
        
        // Register ChatViewModel with its dependencies
        container.register(ChatViewModel.self) { resolver in
            let webserviceManager = resolver.resolve(WebserviceManager.self)!
            let databaseManager = resolver.resolve(DatabaseManager.self)!
            return ChatViewModel(webserviceManager: webserviceManager, databaseManager: databaseManager) // Pass dependencies here
        }
    }

    func chatViewModel() -> ChatViewModel {
        return container.resolve(ChatViewModel.self)! // Resolve the ChatViewModel instance
    }
}
