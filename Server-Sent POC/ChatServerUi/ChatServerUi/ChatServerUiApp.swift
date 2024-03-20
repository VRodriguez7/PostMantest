//
//  ChatServerUiApp.swift
//  ChatServerUi
//
//  Created by Victor Rodriguez on 2/23/24.
//

import SwiftUI

@main
struct ChatServerUiApp: App {
    init() {
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
               print("Permission granted: \(granted)")
           }
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
