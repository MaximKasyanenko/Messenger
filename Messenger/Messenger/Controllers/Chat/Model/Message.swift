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
        
        var messages: [Message] = value.compactMap { dictionary in
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
            
             let dates = dateFormatter.date(from: date)
                
                let sender = Sender(photoURL: "", senderId: senderEmail, displayName: name)
                
                let mesage = Message(sender: sender,
                                     messageId: id,
                                     sentDate: dates ?? Date(),
                                     kind: .text(content))
                return mesage
            
              
        }
            
            return messages
        }
    
    
     func messegeToDictionnary(email: String, nickName: String ) -> [String: Any] {
         let messeges: [String: Any] = [
            "id": messageId,
            "type": kind.description,
            "content": kind.value,
            "date": sentDate.dateFormatString(),
            "sender_email": email,
            "nickName": nickName,
            "isRead": false
        ]
       return messeges
    }
}


