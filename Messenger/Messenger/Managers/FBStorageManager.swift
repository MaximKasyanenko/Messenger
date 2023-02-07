//
//  FBStorageManager.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 07.02.2023.
//
import FirebaseStorage
import Foundation

class FBStorageManager {
    static let shared = FBStorageManager()
    private let storage = Storage.storage().reference()
    private init() {}
    
    /// Uploads picture to firebase storage and returns completion with url string to download
    func uploadProfilePicture(_ data: Data, fileName: String, complition: @escaping (Result<String, Error>) -> ()) {
        storage.child("images/\(fileName)").putData(data) {[weak self] metaData, error in
            if let error = error {
                complition(.failure(error))
            }
            self?.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else { return }
                complition(.success(url.absoluteString))
            }
        }
    }
    
    //func downloadURL(from path: String, complition: @escaping (Result<>) -> ())
}
