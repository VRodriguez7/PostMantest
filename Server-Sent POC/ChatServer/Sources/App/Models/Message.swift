//
//  File.swift
//  
//
//  Created by Victor Rodriguez on 2/23/24.
//

import Foundation
import Vapor
import Fluent

final class Message: Model, Content {
    static let schema = "messages"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String

    @Field(key: "content")
    var content: String

    init() { }

    init(id: UUID? = nil, username: String, content: String) {
        self.id = id
        self.username = username
        self.content = content
    }
}
