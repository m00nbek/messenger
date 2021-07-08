//
//  StorageManager.swift
//  Messenger
//
//  Created by Oybek on 7/7/21.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String, Error>) -> Void
    
    /// Uploads image to Firebase Storage and returns completion with Result<String, Error>
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping UploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metaData, error in
            if error != nil {
                // failed
                guard let error = error else {return}
                print("Failed to upload picture data to firebase. Error: \(error)")
                completion(.failure(StorageError.failedToUpload))
                return
            }
            let reference = self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    print("Failed to get downloadURL")
                    completion(.failure(StorageError.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("URL returned: \(urlString)")
                completion(.success(urlString))
            }
        }
    }
    public enum StorageError: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    public func downloadURL(for path: String, completion: @escaping(Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageError.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))

        }
    }
}
