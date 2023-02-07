//
//  ChatAppUser.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import Foundation

struct ChatAppUser {
    let nickName: String
    let email: String
    var sefeEmail: String { self.email.replacingOccurrences(of: ".", with: "-")}
    var proFileImageNane: String {
        return "\(sefeEmail)_profile_picture.png"
    }
}
