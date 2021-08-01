//
//  WeatherTableViewCell.swift
//  Weather
//
//  Created by Александр Бисеров on 6/11/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let font = UIFont(name: "Helvetica", size: 55)
        label.textColor = .blue
        label.text = "22°"
        label.font = font
        return label
    }()
    
    let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let weatherDataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Helvetica", size: 20)
        label.text = "13.00"
        label.textColor = .black
        label.font = font
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let weatherConditionLabel: UILabel = {
        let label = UILabel()
        let font = UIFont(name: "Helvetica", size: 15)
        label.text = "Clear"
        label.textColor = .black
        label.font = font
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureView() {
        addSubview(temperatureLabel)
        addSubview(weatherConditionImageView)
        addSubview(weatherDataStackView)
        weatherDataStackView.addArrangedSubview(timeLabel)
        weatherDataStackView.addArrangedSubview(weatherConditionLabel)
        setupLayout()
    }
    
    private func setupLayout() {
        temperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        temperatureLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        weatherConditionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
        weatherConditionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        weatherConditionImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        weatherDataStackView.leadingAnchor.constraint(equalTo: weatherConditionImageView.trailingAnchor, constant: 40).isActive = true
        weatherDataStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        weatherDataStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
}
