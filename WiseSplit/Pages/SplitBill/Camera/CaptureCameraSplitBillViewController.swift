import UIKit
import CoreML
import Vision
import AVKit

class CaptureCameraSplitBillViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    var photoOutput: AVCapturePhotoOutput?
    
    let labelIdentifier: UILabel = {
        let label = UILabel()
        label.backgroundColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let captureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Capture", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        button.backgroundColor = Colors.blueCustom
        
        button.setBackgroundImage(UIImage(color: UIColor.lightGray), for: .disabled)
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        //        button.isEnabled = false
        return button
    }()
    
    
    var capturedImageBuffer: CVPixelBuffer?
    var captureSession: AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .photo
        
        photoOutput = AVCapturePhotoOutput()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let captureSession = self?.captureSession else { return }
            
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
            guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
            
            captureSession.addInput(input)
            captureSession.startRunning()
            
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            DispatchQueue.main.async {
                self?.view.layer.addSublayer(previewLayer)
                previewLayer.frame = self?.view.frame ?? .zero
            }
            
            let outputData = AVCaptureVideoDataOutput()
            outputData.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(outputData)
        }
        
        if let photoOutput = photoOutput, let captureSession = captureSession {
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            } else {
                print("Unable to add photo output to capture session.")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        captureSession?.stopRunning()
    }
    
    
    fileprivate func setupIdentifierConfidenceLabel() {
        view.addSubview(labelIdentifier)
        labelIdentifier.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32).isActive = true
        labelIdentifier.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        labelIdentifier.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        labelIdentifier.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    fileprivate func setupCaptureButton() {
        view.addSubview(captureButton)
        captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        captureButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90).isActive = true
        captureButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        captureButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func captureButtonTapped() {
        guard let captureSession = captureSession, let photoOutput = photoOutput else { return }
        self.addLoading(onView: view)
        // Capture a photo
        let photoSettings = AVCapturePhotoSettings()
        if photoOutput.isHighResolutionCaptureEnabled {
            photoSettings.isHighResolutionPhotoEnabled = true
        }
        photoSettings.flashMode = .off
        
        photoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            self.removeLoading()
            return
        }
        guard let capturedImage = UIImage(data: imageData) else {
            self.removeLoading()
            return
        }
        
        
        let imageViewController = ImageViewController()
        imageViewController.capturedImage = capturedImage
        imageViewController.performOCR = true
        
        captureSession?.stopRunning()
        
        navigationController?.pushViewController(imageViewController, animated: true)
        self.removeLoading()
    }
    
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Load the CoreML model
        guard let model = try? VNCoreMLModel(for: ImageReceiptModel().model) else { return }
        
        let request = VNCoreMLRequest(model: model) { [weak self] finishRequest, error in
            guard let results = finishRequest.results as? [VNClassificationObservation], let observation = results.first else { return }
            
            
            DispatchQueue.main.async {
                self?.labelIdentifier.text = "\(observation.identifier) + \(observation.confidence * 100)"
            }
            
            
            if observation.identifier == "receipt" && observation.confidence >= 0.98 {
                DispatchQueue.main.async { [weak self] in
                    print("Receipt detected with confidence >= 0.9. Enabling capture button.")
                    self?.captureButton.isEnabled = true
                }
            }
            
        }
        
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
}
extension UIImage {
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: cgImage)
    }
}

