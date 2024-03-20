import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor


public func configure(_ app: Application) throws {
    // Register Fluent SQLite database
    app.databases.use(.sqlite(.file("ChatServerDB.db")), as: .sqlite)

    // Register migrations
    app.migrations.add(CreateMessage())
    app.migrations.add(CreateMessage())

    // Register routes
    let messageController = MessageController()
    try app.register(collection: messageController)

    // Run migrations
    try app.autoMigrate().wait()
}

