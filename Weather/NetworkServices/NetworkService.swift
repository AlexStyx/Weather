//
//  NetvorkService.swift
//  Weather
//
//  Created by Александр Бисеров on 6/11/21.
//

import Foundation

final class NetworkService {
    
    public var onCompletion: ((WeatherData) -> ())? // will be used for updating UI in ViewControllers
    
    //MARK: - fetchData
    public func fetchData(lat: Double, lon: Double, requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .weather: urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        case .forecast: urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        performRequest(url: url, requestType: requestType)
    }
    //MARK: - performRequest
    private func performRequest(url: URL, requestType: RequestType) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                var result = self?.parseJSON(data: data, typeOfRequest: requestType)
                switch requestType {
                case .weather: result = result as? CurrentWeather;
                case .forecast: result = result as? Forecast
                }
                guard let result = result else {
                    print("Cannot get a result from ParseJSON(data: Data, typeOfRequest: RequestType) -> WeatherData?")
                    return
                }
                self?.onCompletion?(result)
            }
        }
        task.resume()
    }
    
    //MARK: - parseJSON 
    private func parseJSON(data: Data, typeOfRequest: RequestType) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            switch typeOfRequest {
            case .forecast:
                let forecastData = try decoder.decode(ForecastData.self, from: data)
                let forecast = Forecast(forecastData: forecastData)
                return forecast
            case .weather:
                let currentWeatherData =  try decoder.decode(CurrentWeatherData.self, from: data)
                let weather = CurrentWeather(currentWeatherData: currentWeatherData)
                return weather
            }
        } catch let error as NSError{
            print(error.localizedDescription)
        }
        return nil
    }
    
    enum RequestType {
        case weather
        case forecast
    }
}
