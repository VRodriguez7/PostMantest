//
//  Message.swift
//  ChatServerUI
//
//  Created by Victor Rodriguez on 2/28/24.
//

import Foundation

struct Message: Codable, Identifiable {
    var id: UUID = UUID()
    var username: String
    var content: String
}
