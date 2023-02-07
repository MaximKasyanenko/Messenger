//
//  AuthManager.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 06.02.2023.
//

import Foundation
import FirebaseAuth

class AuthManager {
    static let shared = AuthManager()
    
    private let auth = Auth.auth()
    
    
    private init() {}
    
    func createUser(email: String, password: String, complition: @escaping (Result<AuthDataResult, Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                complition(.success(result))
            } else if let error = error {
                complition(.failure(error))
            }
        }
    }
    func logIn(email: String, password: String,  complition: @escaping (Result<AuthDataResult, Error>) -> ()) {
        
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                complition(.success(result))
            } else if let error = error {
                complition(.failure(error))
            }
        }
    }
    
    func checkAuth() -> Bool {
        guard let _ = auth.currentUser else { return false  }
        return true
    }
    
    func signOut() {
        do {
           try auth.signOut()
        } catch {
            print(error)
        }
    }
    
}
