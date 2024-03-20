//
//  ChatViewModel.swift
//  ChatServerUi
//
//  Created by Victor Rodriguez on 2/27/24.
//

import Foundation
import Starscream

class ChatViewModel: ObservableObject {
    private var webSocketTask: URLSessionWebSocketTask?
    @Published var messages: [String] = []
    var username: String = ""
    
    func connect() {
        guard let url = URL(string: "ws://127.0.0.1:8080/chat") else {
            print("Invalid WebSocket URL")
            return
        }
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    func sendMessage(_ message: String) {
        let fullMessage = "\(username): \(message)"
        webSocketTask?.send(.string(fullMessage)) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
    }
    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.messages.append(text)
                    }
                    self?.receiveMessage()
                default:
                    print("Received non-text message: \(message)")
                }
            }
        }
    }
}
