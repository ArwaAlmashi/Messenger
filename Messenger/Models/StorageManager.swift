

import Foundation
import Firebase
import FirebaseStorage
import SDWebImage


final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public func uploadProfileImage(with data: Data, filename: String, completion: @escaping (Result<String, Error>) -> Void)  {
        storage.child("images/\(filename)").putData(data, metadata: nil) { _ , error in
            
            guard error == nil else {
                print("Faild to upload profile image")
                return
            }
            
            self.storage.child("images/\(filename)").downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                
                completion(.success(urlString))
                
            }
        }
    }
    
    public func downloadURL(for path: String,completion: @escaping (Result<URL, Error>) -> Void) {
        
        let reference = storage.child("images/\(path).png")
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
            }
            completion(.success(url))
        }
    }
        
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    
    
}
