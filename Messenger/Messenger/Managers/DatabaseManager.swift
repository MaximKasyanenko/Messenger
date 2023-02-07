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
        dataBase.child(user.sefeEmail).setValue([
            "nickName": user.nickName
        ]) { error, referense in
            guard let error = error else { return }
            print(error)
            
        }
    }
}
