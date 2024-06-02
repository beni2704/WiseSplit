import UIKit

class ImageViewController: UIViewController {
    
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
        button.setTitle("Perform OCR", for: .normal)
        button.addTarget(self, action: #selector(goToOCRViewController), for: .touchUpInside)
        button.isHidden = performOCR ?? false ? false : true
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func goToOCRViewController() {
        let ocrViewController = OCRViewController()
        ocrViewController.capturedImage = capturedImage
        ocrViewController.imageFileName = imageFileName
        
        navigationController?.pushViewController(ocrViewController, animated: true)
    }
    
}
