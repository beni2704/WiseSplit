//
//  GetImageControllerView.swift
//  WiseSplit
//
//  Created by ichiro on 28/04/24.
//

import UIKit

class InitiateSplitBillViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var titleLabel = UILabel()
    var firstText = UILabel()
    var secondText = UILabel()
    var thirdText = UILabel()
    var importButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabel()
    }
    
    private func setLabel(){
        titleLabel.text = "Separate Bill"
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        view.addSubview(titleLabel)
        
        firstText.text = "Capture Your Bill For Us"
        firstText.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(firstText)
        
        secondText.text = "Please upload or take a picture of the bill. This image is required to process and automatically split the total cost among all group members."
        secondText.font = UIFont.preferredFont(forTextStyle: .title3)
        secondText.translatesAutoresizingMaskIntoConstraints = false
        secondText.numberOfLines = 0
        secondText.lineBreakMode = .byWordWrapping
        secondText.textAlignment = .center
        secondText.font = UIFont.systemFont(ofSize: 14.0)
        secondText.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        view.addSubview(secondText)
        
        importButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        importButton.addTarget(self, action: #selector(importButtonTapped), for: .touchUpInside)
        importButton.translatesAutoresizingMaskIntoConstraints = false
        //importButton.tintColor = UIColor.red
        //importButton.backgroundColor = UIColor.label
        view.addSubview(importButton)
        
        thirdText.text = "import"
        thirdText.font = UIFont.preferredFont(forTextStyle: .title3)
        thirdText.translatesAutoresizingMaskIntoConstraints = false
        thirdText.numberOfLines = 0
        thirdText.lineBreakMode = .byWordWrapping
        thirdText.textAlignment = .center
        thirdText.font = UIFont.systemFont(ofSize: 8.0)
        view.addSubview(thirdText)
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            
            firstText.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 225),
            firstText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            secondText.topAnchor.constraint(equalTo: firstText.bottomAnchor, constant: 16),
            secondText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            secondText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            importButton.topAnchor.constraint(equalTo: secondText.bottomAnchor, constant: 16),
            importButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            importButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            thirdText.topAnchor.constraint(equalTo: importButton.bottomAnchor, constant: 5),
            thirdText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            thirdText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            thirdText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
        
    }
    
    @objc private func importButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let viewController = CaptureCameraSplitBillViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        actionSheet.addAction(takePhotoAction)
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] _ in
            self?.presentImagePicker(sourceType: .photoLibrary)
        }
        actionSheet.addAction(chooseFromLibraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Pass the selected image to ImageViewController
            let imageVC = ImageViewController()
            imageVC.capturedImage = selectedImage
            imageVC.performOCR = true // Set this based on your requirement
            navigationController?.pushViewController(imageVC, animated: true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
