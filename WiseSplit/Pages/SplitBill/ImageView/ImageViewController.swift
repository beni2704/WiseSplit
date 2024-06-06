import UIKit

class ImageViewController: UIViewController {
    let ocrVM = OCRViewModel()
    
    var capturedImage: UIImage?
    var imageFileName: String?
    var imageView: UIImageView!
    var performOCR: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = capturedImage
        
        view.addSubview(imageView)
        
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let button = UIButton(type: .system)
        button.setTitle("Perform Split Bill", for: .normal)
        button.addTarget(self, action: #selector(proceedSeparate), for: .touchUpInside)
        button.isHidden = performOCR ?? false ? false : true
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        ocrVM.capturedImage = capturedImage
        ocrVM.performOCR = performOCR ?? false
        
        ocrVM.onOCRSuccess = { [weak self] in
            self?.navigateToSeparateBill()
        }
        
        ocrVM.onOCRError = { error in
            print(error)
        }
    }
    
    @objc func proceedSeparate() {
        addLoading(onView: self.view)
        ocrVM.performOCRRequest()
    }
    
    func navigateToSeparateBill() {
        let separateBillVC = EditBillViewController()
        separateBillVC.capturedImage = capturedImage
        
        let ocrResult = ocrVM.ocrResult
        
        for (index, price) in ocrResult.prices.enumerated() {
            if price.hasPrefix("S") || price.hasPrefix("$") {
                let modifiedPrice = String(price.dropFirst())
                
                if let doublePrice = Double(modifiedPrice) {
                    let multipliedPrice = doublePrice * 16000
                    let integerPrice = Int(multipliedPrice)
                    ocrVM.ocrResult.prices[index] = "\(integerPrice)"
                    passingItemsToEditSplitBill(separateBillVC: separateBillVC)
                } else {
                    print("Invalid price: \(price)")
                }
            } else {
                if let doublePrice = Double(price) {
                    let multipliedPrice = doublePrice * 16000
                    let integerPrice = Int(multipliedPrice)
                    ocrVM.ocrResult.prices[index] = "\(integerPrice)"
                    passingItemsToEditSplitBill(separateBillVC: separateBillVC)
                } else {
                    print("Invalid price: \(price)")
                }
            }
        }
        
        navigationController?.pushViewController(separateBillVC, animated: true)
        removeLoading()
    }
    
    func passingItemsToEditSplitBill(separateBillVC: EditBillViewController) {
        let ocrResult = ocrVM.ocrResult
        separateBillVC.itemNames = ocrResult.itemNames
        separateBillVC.quantities = ocrResult.quantities
        separateBillVC.prices = ocrResult.prices
    }
}
