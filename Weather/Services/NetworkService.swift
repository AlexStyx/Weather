//
//  NetvorkService.swift
//  Weather
//
//  Created by Александр Бисеров on 6/11/21.
//

import Foundation

protocol NetworkServiceDelegate: AnyObject {
    func didUpdateWeatherData(_ weather: Weather)
    func didFailWithError(_ error: Error)
}

final class NetworkService {
    
    public var delegate: NetworkServiceDelegate?
    
    public var onCompletion: ((WeatherData) -> ())? // will be used for updating UI in ViewControllers
    
    public func fetchData(lat: Double, lon: Double, requestType: DataType) {
        guard let url = configureURL(params: params(lat: lat, lon: lon), dataType: requestType) else { fatalError("Cannot configure URL") }
        performRequest(url: url, dataType: requestType)
    }
    
    private func params(lat: Double, lon: Double) -> [String: String] {
        [
            "lat": String(describing: lat),
            "lon": String(describing: lon),
            "appid": apiKey,
            "units": "metric"
        ]
    }
    
    private func configureURL(params: [String: String], dataType: DataType) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/\(dataType == .weather ? "weather" : "forecast")"
        components.queryItems = params.map {URLQueryItem(name: $0, value: $1)}
        return components.url
    }
    
    private func performRequest(url: URL, dataType: DataType) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            if let data = data {
                var result = self?.parseJSON(data: data, typeOfRequest: dataType)
                switch dataType {
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
    private func parseJSON(data: Data, typeOfRequest: DataType) -> WeatherData? {
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
    
    enum DataType {
        case weather
        case forecast
    }
}
