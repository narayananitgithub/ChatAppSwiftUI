Chat Application
This is a scalable chat application built using SwiftUI, showcasing modern iOS development techniques and best practices for scalability and maintainability.

Project Overview
The application allows users to send and receive chat messages, simulating real-time functionality using mock data. It demonstrates the implementation of the MVVM architectural pattern, dependency injection, mock API integration, state management, and local data persistence using SQLite.

Key Features
MVVM Architecture: Clear separation between View, ViewModel, and Model.
Dependency Injection: Implemented using Swinject for managing dependencies and state.
API Integration: Uses Alamofire for fetching user data and messages.
Local Database: Messages and user data are stored locally using SQLite.
State Management: SwiftUI’s state management tools (@State, @ObservedObject, @StateObject, and @EnvironmentObject) are used to manage the app’s state.
Mock Real-Time Messaging: Simulates real-time message updates.
Project Architecture
MVVM Pattern
Model: Defines the message and user structures using Swift’s Codable for JSON parsing.
ViewModel: Manages the app's business logic, API calls, and communicates with both the View and Model layers.
View: The SwiftUI views that bind to the ViewModel for rendering UI updates.
Dependency Injection
Swinject: Used for injecting dependencies such as the ChatViewModel and APIManager.
API Integration
The project integrates with a mock API using Alamofire to fetch user data and messages. It simulates sending and receiving messages in a chat interface.

Alamofire is used for making network requests.
The API is mocked with static data for the assessment.
Local Database
SQLite: Used to persist messages and user information locally.
SQLite is integrated with the app to manage local storage, ensuring the app works offline and stores historical messages and user data.
SQLite Implementation
SQLite.swift framework is used to interact with the SQLite database.
Messages and user details are stored in the database, and the app retrieves this data on launch.
The database schema consists of tables for storing users and messages.
State Management
@State, @ObservedObject, @StateObject, @EnvironmentObject: SwiftUI state management tools are utilized to ensure proper UI updates as the app state changes.
Running the Project
Clone the repository:
bash
Copy code
git clone https://github.com/your-repository-url.git
Open the project in Xcode 15.
Run the project using the iOS simulator or a real device.
To run tests, press Cmd + U to execute the XCTest suite.
Mock Data
Mock API responses simulate the following:

Users: The app fetches user details and messages from a mock data source.
Messages: Simulates message sending and receiving with mock real-time updates.
Example Mock Data
json
Copy code
{
  "users": [
    { "id": "1", "name": "User 1" },
    { "id": "2", "name": "User 2" }
  ],
  "messages": [
    { "id": "1", "content": "Hello!", "userId": "1", "timestamp": "2024-09-27T12:00:00Z" },
    { "id": "2", "content": "Hi there!", "userId": "2", "timestamp": "2024-09-27T12:01:00Z" }
  ]
}
Dependencies
SwiftUI for building the UI.
Alamofire for networking.
Swinject for dependency injection.
SQLite.swift for local data storage.
Future Improvements
Real-time messaging using WebSockets.
User authentication and profile management.
Push notifications for new messages
