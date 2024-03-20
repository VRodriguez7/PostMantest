//
//  File.swift
//  ChatServerUi
//
//  Created by Victor Rodriguez on 3/1/24.
//

import Foundation
import UserNotifications

func scheduleNotification(message: String) {
    let content = UNMutableNotificationContent()
    content.title = "New Chat Message"
    content.body = message
    content.sound = .default

    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false) // For testing, we'll trigger after 5 seconds
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error)")
        }
    }
}
