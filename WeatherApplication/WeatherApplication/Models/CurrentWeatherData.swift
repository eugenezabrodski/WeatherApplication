//
//  CurrentWeatherData.swift
//  WeatherApplication
//
//  Created by Eugene on 11/12/2023.
//

import Foundation


struct CurrentWeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
    let feels_like: Double
}

struct Weather: Decodable {
    let id: Int
}
