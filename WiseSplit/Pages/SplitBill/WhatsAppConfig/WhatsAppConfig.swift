import UIKit

class WhatsAppConfig: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the button
        let whatsappButton = UIButton(type: .system)
        whatsappButton.setTitle("Open WhatsApp", for: .normal)
        whatsappButton.addTarget(self, action: #selector(openWhatsApp), for: .touchUpInside)
        
        // Set button frame or constraints
        whatsappButton.frame = CGRect(x: 50, y: 100, width: 200, height: 50)  // Example frame
        view.addSubview(whatsappButton)
    }

    @objc func openWhatsApp() {
        let phoneNumber = "6281261624408" // Replace with the actual phone number
        let message = "Hello, this is a pre-filled message!" // Replace with your message
        let urlString = "https://api.whatsapp.com/send?phone=\(phoneNumber)&text=\(message)"
        
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                // WhatsApp is not installed
                let alert = UIAlertController(title: "Error", message: "WhatsApp is not installed on this device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        }
    }
}
