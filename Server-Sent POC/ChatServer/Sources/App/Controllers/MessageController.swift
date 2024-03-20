//
//  File.swift
//  
//
//  Created by Victor Rodriguez on 2/23/24.
//

import Foundation
import Vapor

struct MessageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("messages", use: getAllMessages)
        routes.webSocket("chat", onUpgrade: handleWebSocket)
    }

    func getAllMessages(req: Request) throws -> EventLoopFuture<[Message]> {
        return Message.query(on: req.db).all()
    }

    func handleWebSocket(req: Request, ws: WebSocket) {
        ws.onText { ws, text in
            do {
                let message = try JSONDecoder().decode(Message.self, from: Data(text.utf8))
                _ = message.save(on: req.db)
                broadcastMessage(message, to: ws)
            } catch {
                print("Error decoding message: \(error)")
            }
        }
    }

    func broadcastMessage(_ message: Message, to ws: WebSocket) {
        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(message)
            ws.send(String(data: jsonData, encoding: .utf8) ?? "")
        } catch {
            print("Error encoding message: \(error)")
        }
    }
}
