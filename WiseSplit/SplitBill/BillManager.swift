import Foundation
import UIKit

struct BillManager {
    let squareAPIKey: String
    
    init(apiKey: String) {
        self.squareAPIKey = apiKey
    }
    
    func generateBillReceipt(itemNames: [String], quantities: [Int], prices: [String], view: UIView, itemButtonAction: Selector, target: Any) {
        displayBillDetails(itemNames: itemNames, quantities: quantities, prices: prices, view: view, itemButtonAction: itemButtonAction, target: target)
        callSquareAPI(amount: calculateTotalPrice(prices: prices))
    }
    
    private func displayBillDetails(itemNames: [String], quantities: [Int], prices: [String], view: UIView, itemButtonAction: Selector, target: Any) {
        
        view.subviews.forEach { $0.removeFromSuperview() }
        
        
        let itemCount = min(itemNames.count, min(quantities.count, prices.count))
        var previousButton: UIButton?
        for index in 0..<itemCount {
            let itemName = itemNames[index]
            let quantity = quantities[index]
            let price = prices[index]
            
            let button = UIButton(type: .system)
            button.setTitle("\(itemName) - Quantity: \(quantity), Price: \(price)", for: .normal)
            button.addTarget(target, action: itemButtonAction, for: .touchUpInside)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(button)
            
            
            if let previousButton = previousButton {
                button.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 20).isActive = true
            } else {
                button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            }
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
            
            previousButton = button
        }
    }
    
    private func calculateTotalPrice(prices: [String]) -> Double {
        var totalPrice: Double = 0.0
        for priceString in prices {
            let price = parsePriceString(priceString)
            totalPrice += price
        }
        return totalPrice
    }
    
    private func parsePriceString(_ priceString: String) -> Double {
        
        let formattedPrice = priceString.replacingOccurrences(of: "$", with: "")
        return Double(formattedPrice) ?? 0.0
    }
    
    private func callSquareAPI(amount: Double) {
        
        let apiUrl = "https://connect.squareupsandbox.com/v2/payments"
        
        
        guard let url = URL(string: apiUrl) else {
            print("Invalid API URL")
            return
        }
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("2024-03-20", forHTTPHeaderField: "Square-Version")
        request.setValue("Bearer \(squareAPIKey)", forHTTPHeaderField: "Authorization")
        
        
        let requestBody: [String: Any] = [
            "idempotency_key": UUID().uuidString,
            "amount_money": [
                "currency": "USD",
                "amount": Int(amount * 100)
            ],
            "accept_partial_authorization": false,
            "source_id": "EXTERNAL",
            "autocomplete": true,
            "buyer_email_address": "beni@gmail.com",
            "external_details": [
                "source": "Google Pay Payment",
                "type": "SOCIAL"
            ]
        ]
        
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("Error creating JSON data")
            return
        }
        
        
        request.httpBody = jsonData
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Response status code: \(httpResponse.statusCode)")
                
                
                if let responseData = data {
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: responseData, options: [])
                        print("Response data: \(json)")
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
        }
        
        
        task.resume()
    }
}
