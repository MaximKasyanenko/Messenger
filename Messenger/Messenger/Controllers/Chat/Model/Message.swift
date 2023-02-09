//
//  File.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 07.02.2023.
//
import MessageKit
import Foundation

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
    
    
   static func dictionaryToMessages(value: [[String: Any]]) -> [Message] {
        var messages: [Message] = []
    
        messages = value.compactMap { dictionary in
            guard let id = dictionary["id"] as? String,
                  let type = dictionary["type"] as? String,
                  let content = dictionary["content"] as? String,
                  let date = dictionary["date"] as? String,
                  let senderEmail = dictionary["sender_email"] as? String,
                  let name = dictionary["nickName"] as? String,
                  let isread = dictionary["isRead"] as? Bool else { return nil }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .long
            dateFormatter.locale = .current
            
            guard let dates = dateFormatter.date(from: date) else { return nil }
            let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
            
            let mesage = Message(sender: sender,
                                 messageId: id,
                                 sentDate: dates,
                                 kind: .text(content))
            return mesage
        }
        return messages
    }
    
//    func messegeToDictionnary(_ firstMessage: Message, email: String, messege: ) -> [String: Any] {
//         let messeges: [String: Any] = [
//            "id": firstMessage.messageId,
//            "type": firstMessage.kind.description,
//            "content": messege,
//            "date": firstMessage.sentDate.dateFormatString(),
//            "sender_email": email,
//            "nickName": nickName,
//            "isRead": false
//        ]
//    }
}


