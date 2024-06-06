//
//  OCRViewModel.swift
//  WiseSplit
//
//  Created by beni garcia on 06/06/24.
//

import Foundation
import UIKit

class OCRViewModel {
    var ocrResult: OCRResult = OCRResult(quantities: [], itemNames: [], prices: [])
    
    var capturedImage: UIImage?
    var performOCR: Bool = false
    
    var onOCRSuccess: (() -> Void)?
    var onOCRError: ((String) -> Void)?
    
    func performOCRRequest() {
        guard let image = capturedImage else {
            onOCRError?("Captured image is nil.")
            return
        }
        
        guard let compressedData = resizeAndCompressImage(image: image, maxSizeInKB: 1024) else {
            onOCRError?("Failed to resize and compress the image.")
            return
        }
        
        let apiKey = "K86918426688957"
        let urlString = "https://api.ocr.space/parse/image"
        let isOverlayRequired = "true"
        
        guard let url = URL(string: urlString) else {
            onOCRError?("Invalid URL.")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"isOverlayRequired\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(isOverlayRequired)\r\n".data(using: .utf8)!)
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"apikey\"\r\n\r\n".data(using: .utf8)!)
        httpBody.append("\(apiKey)\r\n".data(using: .utf8)!) // Include apiKey parameter
        httpBody.append("--\(boundary)\r\n".data(using: .utf8)!)
        httpBody.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpeg\"\r\n".data(using: .utf8)!)
        httpBody.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        httpBody.append(compressedData)
        httpBody.append("\r\n".data(using: .utf8)!)
        httpBody.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = httpBody as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                self.onOCRError?("Error: \(error)")
                return
            }
            
            guard let data = data else {
                self.onOCRError?("No data received.")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let parsedResults = json["ParsedResults"] as? [[String: Any]] {
                        for result in parsedResults {
                            if let textOverlay = result["TextOverlay"] as? [String: Any],
                               let lines = textOverlay["Lines"] as? [[String: Any]] {
                                for line in lines {
                                    if let lineText = line["LineText"] as? String,
                                       let words = line["Words"] as? [[String: Any]] {
                                        var quantity: String?
                                        var itemName: String?
                                        var price: String?
                                        
                                        for word in words {
                                            if let wordText = word["WordText"] as? String {
                                                if wordText.contains(".") || wordText.contains("$") || wordText.contains(",") {
                                                    price = wordText
                                                    self.ocrResult.prices.append(price!)
                                                    
                                                } else if let number = Int(wordText), wordText.count <= 1 {
                                                    quantity = "\(number)"
                                                    self.ocrResult.quantities.append(quantity!)
                                                    
                                                } else {
                                                    let isValidCharacter = wordText.rangeOfCharacter(from: CharacterSet(charactersIn: "&").union(CharacterSet.letters)) != nil || wordText.contains("-")
                                                    if isValidCharacter && wordText != "x" && wordText != "*" && !wordText.contains("I") &&
                                                        !wordText.contains("#") {
                                                        itemName = (itemName == nil) ? wordText : "\(itemName!) \(wordText)"
                                                        self.ocrResult.itemNames.append(itemName!)
                                                    }
                                                }
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.onOCRSuccess?()
                    }
                } else {
                    self.onOCRError?("Failed to parse JSON.")
                }
            } catch {
                self.onOCRError?("Error parsing JSON: \(error)")
            }
        }.resume()
    }
}
