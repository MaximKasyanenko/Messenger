//
//  FBStorageManager.swift
//  Messenger
//
//  Created by Maksim Kasyanenko on 07.02.2023.
//
import FirebaseStorageUI
import Firebase
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
    
    func downloadProfilePicture(image: UIImageView, email: String = "") {
        guard let senderemail = UserDefaults.standard.string(forKey: "email") else { return }
        let refEmail = email == "" ? senderemail : email
        let reference = storage.child("images/\(refEmail)_profile_picture.png")
        image.sd_setImage(with: reference, placeholderImage: UIImage(systemName: "person"))
    //    image.sd_setImage(with: reference, maxImageSize: 100000, placeholderImage: UIImage(systemName: "person"), options: .avoidDecodeImage)
        }
    
}
