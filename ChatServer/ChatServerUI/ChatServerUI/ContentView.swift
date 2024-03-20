import SwiftUI



struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var newMessageContent = ""

    var body: some View {
        VStack {
            List(viewModel.messages) { message in
                VStack(alignment: .leading) {
                    Text(message.username).font(.headline)
                    Text(message.content).font(.subheadline)
                }
            }

            HStack {
                TextField("New message", text: $newMessageContent)
                Button("Send") {
                    let newMessage = Message(username: "User", content: newMessageContent)
                    viewModel.send(message: newMessage)
                    newMessageContent = ""
                }
            }.padding()
        }
        .onAppear(perform: viewModel.loadMessages)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
