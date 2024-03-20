//
//  File.swift
//  
//
//  Created by Victor Rodriguez on 2/23/24.
//

import Foundation
import Vapor
import Fluent

struct CreateMessage: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("messages")
            .id()
            .field("username", .string, .required)
            .field("content", .string, .required)
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("messages").delete()
    }
}
