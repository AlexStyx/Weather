//
//  ForecastViewController.swift
//  Weather
//
//  Created by Александр Бисеров on 6/10/21.
//

import UIKit
import Foundation
import CoreLocation

final class ForecastTableViewController: UIViewController {
    
    private let networkService = NetworkService()
    private var forecast = Forecast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "London"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setupLayout()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
        networkService.onCompletion = { [weak self] forecast in
            guard let forecast = forecast as? Forecast else { return }
            self?.forecast = forecast
            DispatchQueue.main.async {
                self?.navigationItem.title = self?.forecast.city
                self?.tableView.reloadData()
            }
        }
    }
    
    lazy private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "weatherCell")
        return tableView
    }()
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ForecastTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dailyForecast = forecast.forecast[section + 1] ?? []
        return dailyForecast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath) as! ForecastTableViewCell
        let section = indexPath.section
        let dailyForecast = forecast.forecast[section + 1]!
        let forecastItem = dailyForecast[indexPath.row]
        let image = UIImage(systemName: forecastItem.weatherConditionImageName)
        cell.timeLabel.text = forecastItem.time
        cell.temperatureLabel.text = forecastItem.temperatureString
        cell.weatherConditionLabel.text = forecastItem.condition
        cell.weatherConditionImageView.image = image
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return forecast.forecast.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let secondsPerMinute = 60
        let minutesPerHour = 60
        let hoursPerDay = 24
        let timeInterval = TimeInterval(secondsPerMinute * minutesPerHour*hoursPerDay * (section) + secondsPerMinute * minutesPerHour * 3)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_En")
        dateFormatter.dateFormat = "EEEE"
        let date = Date(timeIntervalSinceNow: timeInterval)
        switch section {
        case 0: return "Today"
        default: return "\(dateFormatter.string(from: date))"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIScreen.main.bounds.height / 15
    }
}

//MARK: - Setup UI
private extension ForecastTableViewController {
    private func setupLayout() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

extension ForecastTableViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else { return }
        updateData(with: coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

private extension ForecastTableViewController {
    private func updateData(with coordinates: CLLocationCoordinate2D) {
        networkService.fetchData(lat: coordinates.latitude, lon: coordinates.longitude, requestType: .forecast)
    }
}


