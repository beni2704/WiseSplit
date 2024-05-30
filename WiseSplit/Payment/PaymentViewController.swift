import UIKit

class PaymentViewController: UIViewController {

    var selectedImage: UIImage? {
        didSet {
            if let imageView = imageView, let image = selectedImage {
                imageView.image = image
            }
        }
    }

    private var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create image view
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Constraints for image view
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0).isActive = true

        // Set the selected image if available
        if let image = selectedImage {
            imageView.image = image
        }
    }
}
