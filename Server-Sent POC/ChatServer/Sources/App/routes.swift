import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    app.webSocket("chat") { req, ws in
        // When receiving a message from the client
        ws.onText { ws, text in
            print("Received message: \(text)")
            // Echo the message back
            ws.send("Echo: \(text)")
        }
    }
    
    app.get("chat") { req -> EventLoopFuture<[Message]> in
           Message.query(on: req.db).all()
       }
    
    func handleWebSocket(req: Request, ws: WebSocket) {
        ChatRoomManager.shared.addConnection(ws)
        ws.onText { ws, text in
            do {
                let message = try JSONDecoder().decode(Message.self, from: Data(text.utf8))
                ChatRoomManager.shared.broadcastMessage(message)
            } catch {
                print("Error decoding message: \(error)")
            }
        }
        
        ws.onClose.whenComplete { _ in
            ChatRoomManager.shared.removeConnection(ws)
        }
    }
    
    
    app.get("chat") { req -> Response in
        // Define HTTP headers specific to SSE
        let headers = HTTPHeaders([
            ("Content-Type", "text/event-stream"), // Set content type as event stream
            ("Cache-Control", "no-cache"), // Ensure responses are not cached
            ("Connection", "keep-alive"), // Keep the connection alive
        ])
        // Create a response with SSE specific headers and a body that streams data
        let response = Response(status: .ok, headers: headers, body: .init(stream: { writer in
            // Schedule a task to send chat messages every second
            _ = req.eventLoop.scheduleRepeatedAsyncTask(initialDelay: .seconds(1), delay: .seconds(1)) { task in
                // Query all messages from the database
                Message.query(on: req.db).all().flatMap { messages in
                    // Convert messages to a string format suitable for SSE and write to the stream
                    let data = messages.map { "data: \($0.username): \($0.content)\n\n" }.joined()
                    return writer.write(.buffer(.init(string: data)))
                }.recover { error in
                    _ = writer.write(.end)
                }
            }
        }))
        return response
    }
}



