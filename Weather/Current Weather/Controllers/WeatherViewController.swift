//
//  WeatherViewController.swift
//  Weather
//
//  Created by Александр Бисеров on 6/10/21.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {

    private let networkService = NetworkService()
    private var currentWeather: CurrentWeather!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Today"
        addSubviews()
        setupLayout()
        networkService.onCompletion = { [weak self] weather in
            if let currentWeather = weather as? CurrentWeather {
                DispatchQueue.main.async {
                    self?.updateUI(currentWeather: currentWeather)
                }
            }
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    lazy private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        return manager
    }()
    
    private let weatherStateImageView: UIImageView = {
        let image = UIImage(systemName: "sun.max")
        let imageView = UIImageView (image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "London, UK"
        label.textColor = .gray
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let weatherLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = "22°C | Sunny"
        label.textColor = .blue
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let feelsLikeLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.preferredFont(forTextStyle: .body)
        label.font = font
        label.text = "Feels like: 20°C"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let upperContainer: UIView = {
        let upperView = UIView()
        upperView.translatesAutoresizingMaskIntoConstraints = false
        return upperView
    }()
    
    private let centerContainer: UIView = {
        let centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        return centerView
    }()
    
    private let line: UILabel = {
        let label = UILabel()
        let font = UIFont.preferredFont(forTextStyle: .title2)
        label.text = "-----------------------------------"
        label.textColor = .gray
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 60
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 60
        return stackView
    }()
    
    private let humidityView: WeatherConditionView? = {
        guard let weatherConditionView = WeatherConditionView(image: UIImage(systemName: "cloud.rain"), data: "57%") else { return nil }
        weatherConditionView.translatesAutoresizingMaskIntoConstraints = false
        return weatherConditionView
    }()
    
    private let precipitationView: WeatherConditionView? = {
        guard let weatherConditionView = WeatherConditionView(image: UIImage(systemName: "drop.triangle"), data: "1.0 mm") else { return nil }
        weatherConditionView.translatesAutoresizingMaskIntoConstraints = false
        return weatherConditionView
    }()

    private let pressureView: WeatherConditionView? = {
        guard let weatherConditionView = WeatherConditionView(image: UIImage(systemName: "rectangle.compress.vertical"), data: "1019 Pa") else { return nil }
        weatherConditionView.translatesAutoresizingMaskIntoConstraints = false
        return weatherConditionView
    }()

    private let windSpeedView: WeatherConditionView? = {
        guard let weatherConditionView = WeatherConditionView(image: UIImage(systemName: "wind"), data: "20 km/h") else { return nil }
        weatherConditionView.translatesAutoresizingMaskIntoConstraints = false
        return weatherConditionView
    }()

    private let windDirectionView: WeatherConditionView? = {
        guard let weatherConditionView = WeatherConditionView(image: UIImage(systemName: "safari"), data: "SE") else { return nil }
        weatherConditionView.translatesAutoresizingMaskIntoConstraints = false
        return weatherConditionView
    }()
    
    private let bottomContainer: UIView = {
        let bottomContainer = UIView()
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        return bottomContainer
    }()
    
    private let updateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Update", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
        return button
    }()
    
    @objc private func updateTapped() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
}

//MARK: - Setup UI
extension WeatherViewController {
    private func setupLayout() {
        upperContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        upperContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        upperContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        upperContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45).isActive = true
        
        weatherStateImageView.centerXAnchor.constraint(equalTo: upperContainer.centerXAnchor).isActive = true
        weatherStateImageView.centerYAnchor.constraint(equalTo: upperContainer.centerYAnchor).isActive = true
        weatherStateImageView.heightAnchor.constraint(equalTo: upperContainer.heightAnchor, multiplier: 0.3).isActive = true
        
        locationLabel.centerXAnchor.constraint(equalTo: upperContainer.centerXAnchor).isActive = true
        locationLabel.topAnchor.constraint(equalTo: weatherStateImageView.bottomAnchor, constant: 10).isActive = true
        
        weatherLabel.centerXAnchor.constraint(equalTo: upperContainer.centerXAnchor).isActive = true
        weatherLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10).isActive = true
        
        feelsLikeLabel.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 5).isActive = true
        feelsLikeLabel.centerXAnchor.constraint(equalTo: upperContainer.centerXAnchor).isActive = true
        
        centerContainer.topAnchor.constraint(equalTo: upperContainer.bottomAnchor, constant: 20).isActive = true
        centerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        centerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        centerContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.27).isActive = true
        
        upperStackView.topAnchor.constraint(equalTo: centerContainer.topAnchor).isActive = true
        upperStackView.centerXAnchor.constraint(equalTo: centerContainer.centerXAnchor).isActive = true
        upperStackView.heightAnchor.constraint(equalTo: centerContainer.heightAnchor, multiplier: 0.5).isActive = true
        
        bottomStackView.topAnchor.constraint(equalTo: upperStackView.bottomAnchor).isActive = true
        bottomStackView.centerXAnchor.constraint(equalTo: centerContainer.centerXAnchor).isActive = true
        bottomStackView.heightAnchor.constraint(equalTo: centerContainer.heightAnchor, multiplier: 0.5).isActive = true

        humidityView?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        precipitationView?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        pressureView?.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        windSpeedView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        windDirectionView!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.15).isActive = true
        
        bottomContainer.topAnchor.constraint(equalTo: centerContainer.bottomAnchor).isActive = true
        bottomContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        updateButton.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        updateButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
    }
    
    private func addSubviews() {
        view.addSubview(upperContainer)
        upperContainer.addSubview(weatherStateImageView)
        upperContainer.addSubview(locationLabel)
        upperContainer.addSubview(weatherLabel)
        upperContainer.addSubview(feelsLikeLabel)
        
        view.addSubview(centerContainer)
        centerContainer.addSubview(upperStackView)
        centerContainer.addSubview(bottomStackView)
        
        upperStackView.addArrangedSubview(humidityView ?? UIView())
        upperStackView.addArrangedSubview(precipitationView ?? UIView())
        upperStackView.addArrangedSubview(pressureView ?? UIView())
        
        bottomStackView.addArrangedSubview(windSpeedView ?? UIView())
        bottomStackView.addArrangedSubview(windDirectionView ?? UIView())
        
        view.addSubview(bottomContainer)
        bottomContainer.addSubview(updateButton)
    }
    
    private func updateUI(currentWeather: CurrentWeather) {
        let image = UIImage(systemName: currentWeather.weatherConditionImageName)
        weatherStateImageView.image = image
        locationLabel.text = currentWeather.locationString
        weatherLabel.text = currentWeather.temperatureAndConditionString
        humidityView?.data = currentWeather.humidityString
        precipitationView?.data = currentWeather.precipitationString
        pressureView?.data = currentWeather.pressureString
        windSpeedView?.data = currentWeather.windSpeedString
        windDirectionView?.data = currentWeather.windDirectionString
        feelsLikeLabel.text = currentWeather.feelsLikeString
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else { return }
        updateData(with: coordinates)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension WeatherViewController {
    private func updateData(with coordinates: CLLocationCoordinate2D) {
        networkService.fetchData(lat: coordinates.latitude, lon: coordinates.longitude, requestType: .weather)
    }
}
