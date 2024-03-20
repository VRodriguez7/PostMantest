import Fluent
import Vapor

func routes(_ app: Application) throws {
    app.get("message") { req in
           Message.query(on: req.db).all()
       }

       app.post("message") { req -> EventLoopFuture<Message> in
           let message = try req.content.decode(Message.self)
           return message.save(on: req.db).map { message }
       }

    app.get("sse") { req -> Response in
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
                    // If an error occurs, cancel the scheduled task and close the stream
                    task.cancel()
                    _ = writer.write(.end)
                }
            }
            
            // Note: Vapor 4 doesn't directly support a request's onClose event for streams.
            // You need to handle task cancellation and stream closure within the task's logic.
        }))
       
        return response
    }
    
    
    try app.register(collection: TodoController())
}
