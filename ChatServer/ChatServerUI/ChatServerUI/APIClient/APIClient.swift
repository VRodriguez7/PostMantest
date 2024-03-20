//
//  APIClient.swift
//  ChatServerUI
//
//  Created by Victor Rodriguez on 2/28/24.
//

import Foundation


class APIClient {
    // The base URL of the chat server. All requests will start with this URL.
    let baseURL = URL(string: "http://localhost:8080/")!

    // Fetches chat messages from the server.
    func fetchMessages(completion: @escaping ([Message]) -> Void) {
        let url = baseURL.appendingPathComponent("messages")
        
        // Initiates a network request to the constructed URL.
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("Error fetching messages: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            // Attempts to decode the received JSON data into an array of `Message` objects.
            do {
                let messages = try JSONDecoder().decode([Message].self, from: data)
                // Dispatches the completion handler on the main thread with the decoded messages.
                DispatchQueue.main.async {
                    completion(messages)
                }
            } catch {
                print("Failed to decode messages: \(error.localizedDescription)")
            }
        }.resume()
    }

    // Sends a new message to the server.
    func sendMessage(_ message: Message, completion: @escaping (Bool) -> Void) {
        let url = baseURL.appendingPathComponent("message")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Encodes the `message` object into JSON and sets it as the HTTP body.
        request.httpBody = try? JSONEncoder().encode(message)
        URLSession.shared.dataTask(with: request) { _, response, error in
            // Checks the response status code to determine if the message was successfully sent.
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200, error == nil else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }
}
