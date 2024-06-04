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
