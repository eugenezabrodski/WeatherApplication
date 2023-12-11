//
//  AlertExtension.swift
//  WeatherApplication
//
//  Created by Eugene on 11/12/2023.
//

import UIKit

extension ViewController {
    
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField { textfield in
            textfield.placeholder = "Enter city"
        }
        
        let search = UIAlertAction(title: "Search", style: .default) { action in
            let textfield = alertController.textFields?.first
            guard let cityName = textfield?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(city)
                //self.networkManager.fetchRequest(forCity: cityName)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancel)
        alertController.addAction(search)
        present(alertController, animated: true)
        
    }
}
