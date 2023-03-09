//
//  StorageManager.swift
//  Messenger
//
//  Created by Станислав Шульц on 03.03.2023.
//

import UIKit
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    
    private var storage = Storage.storage().reference()
    
    public typealias UploadPictureCompleteion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(with data: Data, fileName: String, completeion: @escaping UploadPictureCompleteion) {
        storage.child("images/\(fileName)").putData(data, completion: { metadata, error in
            guard error == nil else {
                print("Failed to upload data to firebase for picture.")
                completeion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download URL.")
                    completeion(.failure(StorageErrors.failedToUpload))
                    return
                }
                
                let urlString = url.absoluteString
                print("Download URL returned: \(urlString)")
                completeion(.success(urlString))
            })
         })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
}
