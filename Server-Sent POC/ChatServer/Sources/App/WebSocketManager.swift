// WebSocketManager.swift

import Vapor

final class WebSocketManager {
    private var activeConnections: [WebSocket] = []
    
    func addConnection(_ ws: WebSocket) {
        ws.eventLoop.execute {
            self.activeConnections.append(ws)
        }
        
        setupHandlers(for: ws)
    }
    
    private func removeConnection(_ ws: WebSocket) {
        ws.eventLoop.execute {
            self.activeConnections.removeAll { $0 === ws }
        }
    }
    
    private func setupHandlers(for ws: WebSocket) {
        ws.onText { ws, text in
            self.broadcast(message: text, from: ws)
        }
        
        ws.onClose.whenComplete { _ in
            self.removeConnection(ws)
        }
    }
    
    private func broadcast(message: String, from sender: WebSocket) {
        activeConnections.forEach { ws in
            if ws !== sender {
                ws.send(message)
            }
        }
    }
}

