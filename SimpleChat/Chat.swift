//
//  Chat.swift
//  SimpleChat
//
//  Created by Khandker  Mahmudur Rahman on 10/9/24.
//

import Foundation

// MARK: - Chat
struct Chat: Codable {
    let message, user: String
    let timestamp: Double
}
