import UIKit
import SwiftUI

class TestViewController: UIViewController {
    // Dummy
    let user: UserTemp = UserTemp(name: "John Doe", total: 100, yearlyData: [
        YearlyData(monthData: [
            MonthData(val1: 0.7, val2: 0.5, val3: 0.9),
            MonthData(val1: 0.4, val2: 0.8, val3: 0.6),
            MonthData(val1: 0.3, val2: 0.2, val3: 0.1),
            MonthData(val1: 0.4, val2: 0.3, val3: 0.2),
            MonthData(val1: 0.5, val2: 0.4, val3: 0.3),
            MonthData(val1: 0.6, val2: 0.5, val3: 0.4),
            MonthData(val1: 0.7, val2: 0.6, val3: 0.5),
            MonthData(val1: 0.8, val2: 0.7, val3: 0.6),
            MonthData(val1: 0.9, val2: 0.8, val3: 0.7),
            MonthData(val1: 0.10, val2: 0.9, val3: 0.8),
            MonthData(val1: 0.11, val2: 0.10, val3: 0.9),
            MonthData(val1: 0.12, val2: 0.11, val3: 0.10),
        ])
    ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let barChartViewModel = BarChartViewModel()
        let barChartView = BarChart(viewModel: barChartViewModel, user: user)
        
        let hostingController = UIHostingController(rootView: barChartView)
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 100)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
