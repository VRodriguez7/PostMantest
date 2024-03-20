////
////  ChatView.swift
////  ChatServerUi
////
////  Created by Victor Rodriguez on 2/27/24.
////
//
//import SwiftUI
//
//struct ChatView: View {
//    @StateObject var viewModel = ChatViewModel()
//    @State private var messageText = ""
//    @State private var showingAlert = true
//    
//    var body: some View {
//        VStack {
//            ScrollView {
//                ForEach(viewModel.messages, id: \.self) { message in
//                    Text(message)
//                        .padding()
//                }
//            }
//            
//            HStack {
//                TextField("Message", text: $messageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                
//                Button("Send") {
//                    viewModel.sendMessage(messageText)
//                    messageText = ""
//                }
//            }.padding()
//        }
//        .onAppear {
//            viewModel.connect()
//        }
//        .onDisappear {
//            viewModel.disconnect()
//        }
//        .alert(isPresented: $showingAlert) {
//            Alert(
//                title: Text("Enter Username"),
//                message: TextField("Username", text: $viewModel.username),
//                dismissButton: .default(Text("OK"))
//            )
//        }
//    }
//}
