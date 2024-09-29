//
//  ChatView.swift
//  ChatAppSwiftUI
//
//  Created by Narayanasamy on 28/09/24.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var viewModel: ChatViewModel

    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollProxy in
                    List {
                        ForEach(viewModel.messages) { message in
                            HStack {
                                if message.userId == "1" {
                                    Spacer()
                                    VStack(alignment: .trailing) {
                                        Text(message.content)
                                            .font(.body)
                                            .padding(10)
                                            .background(Color.blue.opacity(0.7))
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Text(message.timestamp, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        Text(message.content)
                                            .font(.body)
                                            .padding(10)
                                            .background(Color.gray.opacity(0.2))
                                            .cornerRadius(10)
                                        Text(message.timestamp, style: .time)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                            }
                            .id(message.id)
                        }
                    }
                    .onAppear {
                        viewModel.fetchMessages()
                    }
                    .onChange(of: viewModel.messages) { _ in
                        scrollToBottom(using: scrollProxy)
                    }
                }
                HStack {
                    TextField("Type your message...", text: $viewModel.newMessageContent)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: {
                        if !viewModel.newMessageContent.isEmpty {
                            viewModel.sendMessage(content: viewModel.newMessageContent, userId: "1")
                            viewModel.newMessageContent = ""
                        }
                    }) {
                        Text("Send")
                    }
                    .padding()
                }
            }
            .navigationTitle("Chat App")
        }
    }
    // MARK: - scrollToBottom
    private func scrollToBottom(using scrollProxy: ScrollViewProxy) {
        withAnimation {
            if let lastMessage = viewModel.messages.last {
                scrollProxy.scrollTo(lastMessage.id, anchor: .bottom) // Scroll to the last message
            }
        }
    }
}
// MARK: - ChatView
#Preview {
   ChatView()
}
