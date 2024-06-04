//
//  UploadImageFirebase.swift
//  WiseSplit
//
//  Created by beni garcia on 28/05/24.
//

import FirebaseStorage
import UIKit

func uploadImage(path: String, image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    guard let imageData = image.jpegData(compressionQuality: 0.8) else {
        completion(.failure(NSError(domain: "ImageConversionError", code: -1, userInfo: nil)))
        return
    }
    
    let storageRef = Storage.storage().reference()
    let imageRef = storageRef.child("\(path)\(UUID().uuidString).jpg")
    
    let metadata = StorageMetadata()
    metadata.contentType = "image/jpeg"
    
    imageRef.putData(imageData, metadata: metadata) { metadata, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        imageRef.downloadURL { url, error in
            if let error = error {
                completion(.failure(error))
            } else if let url = url {
                completion(.success(url.absoluteString))
            }
        }
    }
}

func downloadImage(for imageUrl: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    let storageRef = Storage.storage().reference(forURL: imageUrl)
    
    storageRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let imageData = data, let image = UIImage(data: imageData) else {
            completion(.failure(NSError(domain: "ImageDataError", code: -1, userInfo: nil)))
            return
        }
        
        completion(.success(image))
    }
}
