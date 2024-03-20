//
//  Message.swift
//  ChatServerUi
//
//  Created by Victor Rodriguez on 2/23/24.
//

import Foundation

struct Message: Decodable, Hashable, Encodable {
    let username: String
    let content: String
}


struct ChatMessage: Identifiable, Codable {
    var id = UUID()
    var username: String
    var content: String
}
