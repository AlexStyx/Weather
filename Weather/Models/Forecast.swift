//
//  Forecast.swift
//  Weather
//
//  Created by Александр Бисеров on 6/14/21.
//

//2021-06-28 09:00:00
//2021-06-28 12:00:00
//2021-06-28 15:00:00
//2021-06-28 18:00:00
//2021-06-28 21:00:00
//2021-06-29 00:00:00
//2021-06-29 03:00:00
//2021-06-29 06:00:00
//2021-06-29 09:00:00
//2021-06-29 12:00:00
//2021-06-29 15:00:00
//2021-06-29 18:00:00
//2021-06-29 21:00:00
//2021-06-30 00:00:00
//2021-06-30 03:00:00
//2021-06-30 06:00:00
//2021-06-30 09:00:00
//2021-06-30 12:00:00
//2021-06-30 15:00:00
//2021-06-30 18:00:00
//2021-06-30 21:00:00
//2021-07-01 00:00:00
//2021-07-01 03:00:00
//2021-07-01 06:00:00
//2021-07-01 09:00:00
//2021-07-01 12:00:00
//2021-07-01 15:00:00
//2021-07-01 18:00:00
//2021-07-01 21:00:00
//2021-07-02 00:00:00
//2021-07-02 03:00:00
//2021-07-02 06:00:00
//2021-07-02 09:00:00
//2021-07-02 12:00:00
//2021-07-02 15:00:00
//2021-07-02 18:00:00
//2021-07-02 21:00:00
//2021-07-03 00:00:00
//2021-07-03 03:00:00
//2021-07-03 06:00:00

import Foundation

class Forecast: WeatherData {
    let city: String?
    var forecast = [Int: [ForecastItem]]()

    init() {self.city = nil}
    init(forecastData: ForecastData) {
        self.city = forecastData.city.name
        var dateString = ""
        var day = 0
        for list in forecastData.list {
            let forecastItem = ForecastItem(list: list)
            if dateString != list.dateString.split(separator: " ")[0] {
                day += 1
                dateString = String(list.dateString.split(separator: " ")[0])
            }
            forecast[day] == nil ? forecast[day] = [forecastItem] : forecast[day]?.append(forecastItem)
        }
    }
}

struct ForecastItem {
    private let temperature: Double
    private let weatherId: Int
    private let dateString: String
    let condition: String
    var time: String {
        let dateStringComponents = dateString.split(separator: " ")
        let timeStringComponents = dateStringComponents[1].split(separator: ":")
        let hours = timeStringComponents[0]
        let minutes = timeStringComponents[1]
        return "\(hours):\(minutes)"
    }

    var temperatureString: String {
        return String(format: "%.0f", temperature) + "°"
    }

    var weatherConditionImageName: String {
        switch weatherId {
        case 200...232: return "cloud.bolt"
        case 300...321: return "cloud.drizzle"
        case 500...531: return "cloud.rain"
        case 600...622: return "cloud.snow"
        case 700...781: return "cloud.fog"
        case 800: return "sun.max"
        case 801...804: return "cloud"
        default: return "nosign"
        }
    }


    init(list: List) {
        self.temperature = list.main.temperature
        self.condition = list.weather.first!.main
        self.weatherId = list.weather.first!.id
        self.dateString = list.dateString
    }
}
