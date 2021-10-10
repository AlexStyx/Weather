//
//  CurrentWeather.swift
//  Weather
//
//  Created by Александр Бисеров on 6/12/21.
//

import Foundation

struct CurrentWeather: WeatherData {
    private let weatherId: Int
    private let city: String
    private let country: String
    private let temperature: Double
    private let feelsLike: Double
    private let humidity: Int
    private let windDirectionInDegrees: Int
    private let precipitation: Double?
    private let pressure: Int
    private let windSpeed: Double
    let condition: String
    
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

    var precipitationString: String {
        return "\((precipitation ?? 0) * 100)mm"
    }
    
    var pressureString: String {
        return "\(pressure)hPa"
    }
    
    var windSpeedString: String {
        return "\(windSpeed)m/s"
    }
    
    var windDirectionString: String {
        switch windDirectionInDegrees {
        case 1...89: return "NE"
        case 0: return "N"
        case 90: return "E"
        case 91...179: return "SE"
        case 180: return "S"
        case 181...269: return "SW"
        case 270: return "W"
        case 271...359: return "NW"
        default: return "No Dir Data"
        }
    }
    
    var locationString: String {
        return city + ", " + country
    }
    
    var temperatureAndConditionString: String {
        return String(format: "%.0f", temperature) + "°" + "C" + " | " + condition
    }
    
    var feelsLikeString: String {
        return "Feels like: " + String(format: "%.0f", feelsLike) + "°" + "C"
    }
    
    var humidityString: String {
        return String(humidity) + "%"
    }
    
    init(currentWeatherData: CurrentWeatherData) {
        self.weatherId = currentWeatherData.weather.first?.id ?? 0
        self.city = currentWeatherData.name
        self.country = currentWeatherData.sys.country
        self.temperature = currentWeatherData.main.temperature
        self.feelsLike = currentWeatherData.main.feelsLike
        self.humidity = currentWeatherData.main.humidity
        self.windDirectionInDegrees = currentWeatherData.wind.deg
        self.precipitation = currentWeatherData.rain?.the1H ?? 0
        self.pressure = currentWeatherData.main.pressure
        self.windSpeed = currentWeatherData.wind.speed
        self.condition = currentWeatherData.weather.first?.main ?? ""
    }
}

protocol WeatherData {}
