//
//  CurrentWeatherData.swift
//  Weather
//
//  Created by Александр Бисеров on 6/18/21.
//

import Foundation

struct CurrentWeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let rain: Rain?
    let wind: Wind
    let sys: Sys
    let name: String
}


struct Weather: Codable {
    let id: Int
    let main: String
}

struct Main: Codable {
    let temperature: Double
    let feelsLike: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case feelsLike = "feels_like"
        case pressure
        case humidity
    }
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
}

struct Rain: Codable {
    let the1H: Double?

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}

struct Sys: Codable {
    let country: String
}



