//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Eugene on 11/12/2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsTemperatureLabel: UILabel!
    
    var networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateUI(weather: currentWeather)
        }
        networkManager.fetchRequest(forCity: "Minsk")
        
    }

    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkManager.fetchRequest(forCity: city)
        }
    }
    
    func updateUI(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsTemperatureLabel.text = weather.feelsLikeTempString + " °C"
            self.weatherIconImage.image = UIImage(systemName: weather.systemIconName)
        }
    }
    
}

