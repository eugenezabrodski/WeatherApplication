//
//  ViewController.swift
//  WeatherApplication
//
//  Created by Eugene on 11/12/2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsTemperatureLabel: UILabel!
    
    var networkManager = NetworkManager()
    lazy var locationManager: CLLocationManager = {
        let locatMan = CLLocationManager()
        locatMan.delegate = self
        locatMan.desiredAccuracy = kCLLocationAccuracyKilometer
        locatMan.requestWhenInUseAuthorization()
        return locatMan
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateUI(weather: currentWeather)
        }
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.requestLocation()
        }
    }

    @IBAction func searchButton(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Enter city name", message: nil, style: .alert) { [unowned self] city in
            self.networkManager.currentWeather(forRequestType: .cityName(city: city))
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

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        
        networkManager.currentWeather(forRequestType: .coordinate(lat: lat, long: long))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

