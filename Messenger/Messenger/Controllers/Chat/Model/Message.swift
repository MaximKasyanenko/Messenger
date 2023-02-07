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
}
