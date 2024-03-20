//
//  ChatViewModel.swift
//  ChatServerUI
//
//  Created by Victor Rodriguez on 2/28/24.
//

import Foundation


import Foundation

// ChatViewModel is responsible for managing the chat data (messages) and interacting with the API.
class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    private let apiClient = APIClient()
    func loadMessages() {
        apiClient.fetchMessages { messages in
            DispatchQueue.main.async {
                self.messages = messages
            }
        }
    }
    func send(message: Message) {
        apiClient.sendMessage(message) { success in
            if success {
                self.loadMessages()
            }
        }
    }
}
