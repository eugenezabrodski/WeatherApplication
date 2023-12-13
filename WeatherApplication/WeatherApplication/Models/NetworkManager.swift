

//
//  NetworkManager.swift
//  WeatherApplication
//
//  Created by Eugene on 11/12/2023.
//

import Foundation
import CoreLocation

class NetworkManager {
    
    enum RequestType {
        case cityName(city: String)
        case coordinate(lat: CLLocationDegrees, long: CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func currentWeather(forRequestType: RequestType) {
        var urlString = ""
        switch forRequestType {
        case .cityName(let city):
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiConstantKey)&units=metric"
        case .coordinate(let lat, let long):
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(apiConstantKey)&units=metric"
        }
        fetchRequest(withURLString: urlString)
    }
    
    
    fileprivate func fetchRequest(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(currentWeatherData: currentWeatherData) else { return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
