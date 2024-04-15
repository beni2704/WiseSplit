//
//  AddPaymentDatePicker.swift
//  WiseSplit
//
//  Created by beni garcia on 13/04/24.
//

import Foundation
import UIKit

extension AddPaymentViewController {
    func setupDatePicker() {
        let datePickerContainerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 200))

        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.contentHorizontalAlignment = .center
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePickerContainerView.addSubview(datePicker)
        
        datePicker.centerXAnchor.constraint(equalTo: datePickerContainerView.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: datePickerContainerView.centerYAnchor).isActive = true
        
        // Set the container view as the input view for dateTF
        dateTF.inputView = datePickerContainerView
    }
    
    @objc private func datePickerValueChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        dateTF.text = dateFormatter.string(from: datePicker.date)
    }
}
