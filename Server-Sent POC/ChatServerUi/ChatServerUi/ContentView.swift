//
//  ContentView.swift
//  ChatServerUi
//
//  Created by Victor Rodriguez on 2/23/24.
//

import SwiftUI
import Starscream

struct ContentView: View {
    @State private var username = ""
    @State private var content = ""
    @State private var messages: [Message] = []
    @StateObject private var socketManager = WebSocketManager()
    
    
    func connectWebSocket() {
        socketManager.connect(username: username) { message in
            messages.append(message)
        }
    }
    
    func sendMessage() {
        let message = Message(username: username, content: content)
        socketManager.sendMessage(message)
        content = ""
    }


    var body: some View {
        VStack {
            if socketManager.isConnected {
                List(messages, id: \.self) { message in
                    VStack(alignment: .leading) {
                        Text(message.username)
                            .font(.headline)
                        Text(message.content)
                            .font(.body)
                       
                    }
                    
                }
                .padding()
            } else {
                VStack {
                    TextField("Enter username", text: $username)
                        .padding()
                    Button("Connect", action: connectWebSocket)
                        .padding()
                }
            }
            HStack {
                TextField("Enter message", text: $content)
                    .padding()
                Button("Send", action: sendMessage)
                    .padding()
                    .disabled(!socketManager.isConnected)
            }
        }
        .padding()
    }



}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




