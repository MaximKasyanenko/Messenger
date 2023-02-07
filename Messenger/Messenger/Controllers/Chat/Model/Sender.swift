//
//  Sender.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 07.02.2023.
//

import MessageKit
import Foundation

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}
