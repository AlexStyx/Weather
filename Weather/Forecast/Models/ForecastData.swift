//
//  ForecastData.swift
//  Weather
//
//  Created by Александр Бисеров on 6/14/21.
//

import Foundation

struct ForecastData: Codable {
    let list: [List]
    let city: City
}

struct City: Codable {
    let name: String
    let country: String
}

struct List: Codable {
    let dateString: String
    let main: Main
    let wind: Wind
    let weather: [Weather]
    let probabilityOfPrecipitation: Double
    
    enum CodingKeys: String, CodingKey {
        case dateString = "dt_txt"
        case probabilityOfPrecipitation = "pop"
        case weather
        case main
        case wind
    }
}

