//
//  ChatView.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatViewModel // Use EnvironmentObject here

    var body: some View {
        NavigationView {
            VStack {
                List(viewModel.messages) { message in
                    HStack {
                        if message.userId == "1" {
                            // Message from the user (right side)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(message.content)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                Text(message.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        } else {
                            // Message from other users (left side)
                            VStack(alignment: .leading) {
                                Text(message.content)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(10)
                                Text(message.timestamp, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                    .padding(.vertical, 5)
                }
                
                // Add a TextField for sending messages
                HStack {
                    TextField("Type your message...", text: $viewModel.newMessageContent)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minHeight: 40)
                        .padding()
                    
                    Button(action: {
                        viewModel.sendMessage(content: viewModel.newMessageContent, userId: "1") // Example user ID
                        viewModel.newMessageContent = "" // Clear input after sending
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .background(Color(.systemGray6))
            }
            .navigationTitle("Chat App")
            .onAppear {
                viewModel.fetchMessages() // Load messages when the view appears
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .environmentObject(ChatViewModel(webserviceManager: <#WebserviceManager#>, databaseManager: <#DatabaseManager#>)) // Provide a preview environment object
    }
}
