//
//  CompressImage.swift
//  WiseSplit
//
//  Created by beni garcia on 01/06/24.
//

import Foundation
import UIKit

func compressImage(_ image: UIImage, to targetSizeInMB: CGFloat = 1.0) -> Data? {
    let targetSizeInBytes = targetSizeInMB * 1024 * 1024
    var compressionQuality: CGFloat = 1.0
    var compressedData = image.jpegData(compressionQuality: compressionQuality)
    
    while let data = compressedData, data.count > Int(targetSizeInBytes) {
        compressionQuality -= 0.9
        compressedData = image.jpegData(compressionQuality: compressionQuality)
    }
    
    return compressedData
}

func resizeAndCompressImage(image: UIImage, maxSizeInKB: Int) -> Data? {
    let maxFileSize = maxSizeInKB * 1024
    var compression: CGFloat = 1.0
    var imageData = image.jpegData(compressionQuality: compression)
    
    let maxSize: CGFloat = 1024
    var newSize = image.size
    if newSize.width > maxSize || newSize.height > maxSize {
        let aspectRatio = newSize.width / newSize.height
        if newSize.width > newSize.height {
            newSize.width = maxSize
            newSize.height = maxSize / aspectRatio
        } else {
            newSize.height = maxSize
            newSize.width = maxSize * aspectRatio
        }
        UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageData = newImage?.jpegData(compressionQuality: compression)
    }
    
    while let data = imageData, data.count > maxFileSize, compression > 0.1 {
        compression -= 0.1
        imageData = image.jpegData(compressionQuality: compression)
    }
    
    return imageData
}
