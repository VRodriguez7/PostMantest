//
//  WebSocketManager.swift
//  ChatServerUi
//
//  Created by Victor Rodriguez on 2/26/24.
//

import Foundation
import Starscream

class WebSocketManager: ObservableObject {
    @Published var isConnected = false

    private var socket: WebSocket?

    func connect(username: String, onMessageReceived: @escaping (Message) -> Void) {
        var request = URLRequest(url: URL(string: "ws://localhost:8080/chat")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket?.onEvent = { event in
            switch event {
            case .connected:
                self.isConnected = true
            case .disconnected(_, _):
                self.isConnected = false
            case .text(let text):
                if let data = text.data(using: .utf8),
                   let message = try? JSONDecoder().decode(Message.self, from: data) {
                    onMessageReceived(message)
                }
            default:
                break
            }
        }
        socket?.connect()
    }

    func sendMessage(_ message: Message) {
        if let data = try? JSONEncoder().encode(message),
           let jsonString = String(data: data, encoding: .utf8) {
            socket?.write(string: jsonString)
        }
    }
}
