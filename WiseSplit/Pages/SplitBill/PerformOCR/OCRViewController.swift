import UIKit
import NaturalLanguage

class OCRViewController: UIViewController {
    
    var capturedImage: UIImage?
    var imageFileName: String?
    
    private var recognizedTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private var billDetailsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(.black, for: .normal)
        button.addTarget(OCRViewController.self, action: #selector(showBillDetails), for: .touchUpInside)
        return button
    }()
    
    
    public var quantities: [String] = []
    public var itemNames: [String] = []
    public var prices: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "OCR using OCR.space API"
        titleLabel.font = UIFont.systemFont(ofSize: 5, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let recognizeButton = UIButton(type: .system)
        recognizeButton.setTitle("Recognize Text", for: .normal)
        recognizeButton.addTarget(self, action: #selector(performOCR), for: .touchUpInside)
        recognizeButton.translatesAutoresizingMaskIntoConstraints = false
        
        let separateBillButton = UIButton(type: .system)
        separateBillButton.setTitle("Separate Billing", for: .normal)
        separateBillButton.addTarget(self, action: #selector(showSeparateBill), for: .touchUpInside)
        separateBillButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separateBillButton)
        
        recognizedTextLabel.text = ""
        recognizedTextLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        view.addSubview(recognizeButton)
        view.addSubview(recognizedTextLabel)
        view.addSubview(billDetailsButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            recognizeButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            recognizeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            recognizedTextLabel.topAnchor.constraint(equalTo: recognizeButton.bottomAnchor, constant: 20),
            recognizedTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            recognizedTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            recognizedTextLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            separateBillButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separateBillButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            billDetailsButton.topAnchor.constraint(equalTo: recognizedTextLabel.bottomAnchor, constant: 20),
            billDetailsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            billDetailsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
    }
    
    @objc public func performOCR() {
        self.addLoading(onView: view)
        performOCRRequest()
        
    }
    
    public func performOCRRequest() {
        guard let image = capturedImage else {
            print("Captured image is nil.")
            removeLoading()
            return
        }
        
        guard let compressedData = resizeAndCompressImage(image: image, maxSizeInKB: 1024) else {
            print("Failed to resize and compress the image.")
            removeLoading()
            return
        }
        
        let apiKey = "K86918426688957"
        let urlString = "https://api.ocr.space/parse/image"
        let isOverlayRequired = "true"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            removeLoading()
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
                print("Error: \(error)")
                self.removeLoading()
                return
            }
            
            guard let data = data else {
                print("No data received.")
                self.removeLoading()
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    var items: [(name: String, quantity: Int, price: Double)] = []
                    var totalPrice: Double = 0.0
                    
                    // Assuming `json` is your JSON response dictionary
                   

                    if let parsedResults = json["ParsedResults"] as? [[String: Any]] {
                        let tagger = NLTagger(tagSchemes: [.lexicalClass])
                        for result in parsedResults {
                            print("json: ", json)
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
                                                    self.prices.append(price!)
                                                } else if let number = Int(wordText), wordText.count <= 1 {
                                                    quantity = "\(number)"
                                                    self.quantities.append(quantity!)
                                                } else {
                                                    // Validation for all-uppercase strings
                                                    let isAllUppercase = wordText == wordText.uppercased()

                                                    // Validation for date, month, year formats
                                                    let dateFormats = ["dd/MM/yyyy", "MM/dd/yyyy", "yyyy/MM/dd", "dd-MM-yyyy", "MM-dd-yyyy", "yyyy-MM-dd"]
                                                    let dateFormatter = DateFormatter()
                                                    var isDate = false

                                                    for format in dateFormats {
                                                        dateFormatter.dateFormat = format
                                                        if dateFormatter.date(from: wordText) != nil {
                                                            isDate = true
                                                            break
                                                        }
                                                    }

                                                    let isMonth = Calendar.current.monthSymbols.contains(wordText)
                                                    let isYear = Int(wordText) != nil && wordText.count == 4

                                                    // Validate if the word is a noun
                                                    tagger.string = wordText
                                                    let tag = tagger.tag(at: wordText.startIndex, unit: .word, scheme: .lexicalClass).0
                                                    let isNoun = tag == .noun || tag == .otherWord

                                                    // Specific checks to exclude "Bank", "bank", "Bank Card", "bank card"
                                                    let excludedWords = ["xxx"]
                                                    let isExcludedWord = excludedWords.contains(wordText)

                                                    let isValidCharacter = wordText.rangeOfCharacter(from: CharacterSet(charactersIn: "&").union(CharacterSet.letters)) != nil || wordText.contains("-")
                                                    if isValidCharacter && wordText != "x" && wordText != "*" && !wordText.contains("I") && !wordText.contains("#") &&
                                                        !isAllUppercase && !isDate && !isMonth && !isYear && isNoun && !isExcludedWord {
                                                        itemName = (itemName == nil) ? wordText : "\(itemName!) \(wordText)"
                                                        self.itemNames.append(itemName!)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }



                    
                    DispatchQueue.main.async { [self] in
                        
                        self.updateUIWithReceiptDetails(items: items, totalPrice: totalPrice)
                        print("Quantities: \(self.quantities)")
                        
                        
                        print("Item Names: \(self.itemNames)")
                        
                        
                        print("Prices: \(self.prices)")
                        
                        let receiptDetails = self.generateReceiptDetails(items: items, totalPrice: totalPrice)
                        self.billDetailsButton.setTitle(receiptDetails, for: .normal)
                        removeLoading()
                    }
                } else {
                    print("Failed to parse JSON.")
                    self.removeLoading()
                }
            } catch {
                print("Error parsing JSON: \(error)")
                self.removeLoading()
            }
        }.resume()
    }
    
    private func resizeAndCompressImage(image: UIImage, maxSizeInKB: Int) -> Data? {
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
    
    private func updateUIWithReceiptDetails(items: [(name: String, quantity: Int, price: Double)], totalPrice: Double) {
        var receiptDetails = "Receipt Details:\n\n"
        
        for item in items {
            receiptDetails += "Item: \(item.name)\n"
            receiptDetails += "Quantity: \(item.quantity)\n"
            receiptDetails += "Price: \(item.price)\n\n"
        }
        
        receiptDetails += "Total Price: \(totalPrice)"
        
        recognizedTextLabel.text = receiptDetails
    }
    
    
    @objc public func showSeparateBill() {
        let separateBillVC = EditBillViewController()
        separateBillVC.capturedImage = capturedImage
        
        for (index, price) in prices.enumerated() {
            if price.hasPrefix("S") || price.hasPrefix("$") {
                let modifiedPrice = String(price.dropFirst())
                
                if let doublePrice = Double(modifiedPrice) {
                    let multipliedPrice = doublePrice * 16000
                    let integerPrice = Int(multipliedPrice)
                    prices[index] = "\(integerPrice)"
                    passingItemsToEditSplitBill(separateBillVC: separateBillVC)
                } else {
                    print("Invalid price: \(price)")
                }
            } else {
                if let doublePrice = Double(price) {
                    let multipliedPrice = doublePrice * 16000
                    let integerPrice = Int(multipliedPrice)
                    prices[index] = "\(integerPrice)"
                    passingItemsToEditSplitBill(separateBillVC: separateBillVC)
                } else {
                    print("Invalid price: \(price)")
                }
            }
        }

        
        
        navigationController?.pushViewController(separateBillVC, animated: true)
        
    }
    
    private func passingItemsToEditSplitBill(separateBillVC: EditBillViewController) {
        separateBillVC.itemNames = itemNames
        separateBillVC.quantities = quantities
        separateBillVC.prices = prices
    }
    
    private func generateReceiptDetails(items: [(name: String, quantity: Int, price: Double)], totalPrice: Double) -> String {
        var receiptDetails = "Receipt Details:\n\n"
        
        for item in items {
            receiptDetails += "Item: \(item.name)\n"
            receiptDetails += "Quantity: \(item.quantity)\n"
            receiptDetails += "Price: \(item.price)\n\n"
        }
        
        receiptDetails += "Total Price: \(totalPrice)"
        
        return receiptDetails
    }
    
    
    @objc private func showBillDetails() {
        
        let alert = UIAlertController(title: "Bill Details", message: billDetailsButton.title(for: .normal), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
