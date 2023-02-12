//
//  DatabaseManager.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//
import FirebaseDatabase
import Foundation

class DatabaseManager {
    static let shared = DatabaseManager()
    private let dataBase = Database.database(url: "https://messeger-7131e-default-rtdb.europe-west1.firebasedatabase.app/").reference()
    private init() {}
    
    func insertUser(user: ChatAppUser) {
        UserDefaults.standard.set(user.sefeEmail, forKey: "email")
        UserDefaults.standard.set(user.nickName, forKey: "name")
        dataBase.child(user.sefeEmail).setValue([
            "nickName": user.nickName
        ]) { error, _ in
            guard let error = error else { return }
            print(error)
        }
        // create the users array wich search
        dataBase.child("users").observeSingleEvent(of: .value) {[weak self] snapshot, _   in
            var newCollection: [[String: String]] = []
            if var usersCollection = snapshot.value as? [[String: String]] {
                usersCollection.append([
                    "nickName": user.nickName,
                    "email": user.sefeEmail
                ])
                newCollection = usersCollection
            } else {
                // create the array
                newCollection = [[
                    "nickName": user.nickName,
                    "email": user.sefeEmail
                ]]
            }
            self?.dataBase.child("users").setValue(newCollection)
        }
    }
    
    func downloadUsers(complition: @escaping ([[String: String]]) -> ()) {
        dataBase.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let collection = snapshot.value as? [[String: String]] else { return }
            complition(collection)
        }
    }
}
//MARK: - Chat -


extension DatabaseManager {
    /// Creates a new conversation with target user email and first message sent
    func createNewConversation (with otherUserEmail: String, firstMessage: Message, nickName: String, completion: @escaping (Bool) -> Void) {
        guard let curentEmail = UserDefaults.standard.string(forKey: "email"),
        let name = UserDefaults.standard.string(forKey: "name") else { return }
        
        dataBase.child(curentEmail).observeSingleEvent(of: .value) { [ weak self]  snapshot, _  in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                return
            }
            let messege = firstMessage.kind.value
            let newConversationData: [String: Any] = [
                "id": "Conversation\(firstMessage.messageId)",
                "other_user_email": otherUserEmail,
                "nickName": nickName,
                "latest_message": [
                    "date": Date().dateFormatString(),
                    "message": messege,
                    "is_read": false
                ]
            ]
            
            let recipient_newConversationData: [String: Any] = [
                "id": "Conversation\(firstMessage.messageId)",
                "other_user_email": curentEmail,
                "nickName": name,
                "latest_message": [
                    "date": Date().dateFormatString(),
                    "message": messege,
                    "is_read": false
                ]
            ]
            // recipient_newConversationData
            self?.dataBase.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [ weak self]  snapshot, _  in
                if var conversations = snapshot.value as? [[String: Any]] {
                    conversations.append(recipient_newConversationData)
                    self?.dataBase.child("\(otherUserEmail)/conversations").setValue(conversations)
                } else {
                    self?.dataBase.child("\(otherUserEmail)/conversations").setValue([recipient_newConversationData])
                    
                }
            }
            
            //user conversations
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                self?.dataBase.child(curentEmail).setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(nickName: nickName, conversationID: "Conversation\(firstMessage.messageId)",
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                }
            } else {
                userNode["conversations"] =  [newConversationData]
                self?.dataBase.child(curentEmail).setValue(userNode) { error, _ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(nickName: nickName, conversationID: "Conversation\(firstMessage.messageId)",
                                                     firstMessage: firstMessage,
                                                     completion: completion)
                    
                }
                
            }
        }
    }
    
    private func finishCreatingConversation (nickName: String, conversationID: String, firstMessage: Message, completion: @escaping (Bool) -> Void) {
       // let messege = firstMessage.kind.value
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        let messeges: [String: Any] = firstMessage.messegeToDictionnary(email: email, nickName: nickName)
        
        let value: [String: Any] = ["messages": [messeges]]
        
        dataBase.child(conversationID).setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    ///Fetches and returns all conversations for the user with passed in email
    func getAllConversations (for email: String, completion: @escaping (Result<[Conversation], Error>) -> Void) {
        dataBase.child("\(email)/conversations").observe(.value) { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else { return }
            let conversations = Conversation.dictionaryToConversation(value: value)
            
            completion(.success(conversations))
        }
    }
    
    /// Gets all messages for a given conversation
    func getAllMessagesForConversation(with id: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        dataBase.child("\(id)/messages").observe(.value) { snapshot, _  in
            guard let value = snapshot.value as? [[String: Any]] else { return }
            
            let messages: [Message] = Message.dictionaryToMessages(value: value)
            
            completion(.success(messages))
        }
    }
    // Sends a message with target conversation and message
    func sendMessage (id conversation: String, otherUserEmail: String, message: Message, completion: @escaping (Bool) -> () ) {
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let nickName = UserDefaults.standard.string(forKey: "name") else { return }
        
        self.dataBase.child("\(conversation)/messages").observeSingleEvent(of: .value) { [weak self] snapshot, _  in
            guard var value = snapshot.value as? [[String: Any]] else {
                completion(false)
                return }
            let messege = message.kind.value
            
            let messeges: [String: Any] =  message.messegeToDictionnary(email: email, nickName: nickName)
               
            value.append(messeges)
            self?.dataBase.child("\(conversation)/messages").setValue(value) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                // curent user last message
                self?.refresLastMessage(email: email, id: conversation, message: messege)
                // resipient user last message
                self?.refresLastMessage(email: otherUserEmail, id: conversation, message: messege)
                
                completion(true)
            }
        }
        
    }
    
    private func refresLastMessage(email: String, id: String, message: String) {
        dataBase.child("\(email)/conversations").observeSingleEvent(of: .value) {[weak self] snapshot, _  in
            guard var value = snapshot.value as? [[String: Any]] else { return }
            let newValue: [String: Any] = [
                "date": Date().dateFormatString(),
                "message": message,
                "is_read": false
            ]
            var targetConvers: [String: Any] = [:]
            var position = 0
            for convers in value {
                if let curentId = convers["id"] as? String, curentId == id {
                    targetConvers = convers
                    break
                }
                position += 1
            }
            targetConvers["latest_message"] = newValue
            value[position] = targetConvers
            self?.dataBase.child("\(email)/conversations").setValue(value)
        }
    }

}
