//
//  WeatherConditionView.swift
//  Weather
//
//  Created by Александр Бисеров on 6/11/21.
//

import UIKit

class WeatherConditionView: UIView {
    
    var image: UIImage? { didSet { weatherConditionImageView.image = image } }
    var data: String? { didSet { weatherConditionLabel.text = data ?? ""} }
    
    convenience init?(image: UIImage?, data: String?) {
        self.init()
        guard image != nil, data != nil else { return nil }
        configureView(image: image!, data: data!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private let weatherConditionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let weatherConditionLabel: UILabel = {
        let label = UILabel()
        let font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = ""
        label.textColor = .gray
        label.font = font
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func configureView(image: UIImage, data: String) {
        self.image = image
        self.data = data
        weatherConditionLabel.text = data
        weatherConditionImageView.image = image
        addSubview(weatherConditionImageView)
        addSubview(weatherConditionLabel)
        setupLayout()
    }
    
    private func setupLayout() {
        weatherConditionImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        weatherConditionImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        weatherConditionImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        weatherConditionImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        weatherConditionLabel.topAnchor.constraint(equalTo: weatherConditionImageView.bottomAnchor, constant: 5).isActive = true
        weatherConditionLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        weatherConditionLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        weatherConditionImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
    }
    
}
