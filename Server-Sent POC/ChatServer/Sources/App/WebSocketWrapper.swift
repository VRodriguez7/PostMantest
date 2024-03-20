//
//  File.swift
//  
//
//  Created by Victor Rodriguez on 2/23/24.
//

import Foundation
import Vapor

final class WebSocketWrapper: Hashable {
    static func == (lhs: WebSocketWrapper, rhs: WebSocketWrapper) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    let id = UUID()
    let socket: WebSocket

    init(_ socket: WebSocket) {
        self.socket = socket
    }
}

final class ChatRoomManager {
    static let shared = ChatRoomManager()

    private var connections: Set<WebSocketWrapper>

    private init() {
        self.connections = Set<WebSocketWrapper>()
    }

    func addConnection(_ ws: WebSocket) {
        let wrapper = WebSocketWrapper(ws)
        connections.insert(wrapper)
    }

    func removeConnection(_ ws: WebSocket) {
        let wrapper = WebSocketWrapper(ws)
        connections.remove(wrapper)
    }

    func broadcastMessage(_ message: Message) {
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(message)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            for connection in connections {
                connection.socket.send(jsonString)
            }
        } catch {
            print("Error encoding message: \(error)")
        }
    }
}
