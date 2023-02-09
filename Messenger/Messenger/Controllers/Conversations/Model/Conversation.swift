//
//  Conversation.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 09.02.2023.
//

import Foundation

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
    
    static func dictionaryToConversation(value: [[String: Any]]) -> [Conversation] {
        let conversations: [Conversation] = value.compactMap({dictionary in
            guard let conversationId = dictionary["id"] as? String,
                  let name = dictionary[ "nickName"] as? String,
                  let otherUserEmail = dictionary["other_user_email"] as? String,
                  let latestMessage = dictionary[ "latest_message"] as? [String: Any],
                  let date = latestMessage["date"] as? String,
                  let message = latestMessage[ "message" ] as? String,
                  let isRead = latestMessage[ "is_read" ] as? Bool else { return nil }
            let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
            let conversation = Conversation(id: conversationId,
                                            name: name,
                                            otherUserEmail: otherUserEmail,
                                            latestMessage: latestMessageObject)
            return conversation
        })
        return conversations
    }
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
