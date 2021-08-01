//
//  MainTabBarController.swift
//  Weather
//
//  Created by Александр Бисеров on 6/10/21.
//

import UIKit

final class MainTabBarController: UITabBarController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewControllers = [
            generateNavigationController(with: "Weather", image: UIImage(systemName: "sun.max"), rootViewController: WeatherViewController()),
            generateNavigationController(with: "Forecast", image: UIImage(systemName: "cloud.sun"), rootViewController: ForecastTableViewController()),
        ]
        
    }
    
    private func generateNavigationController(with title: String, image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        if let image = image {
            navigationVC.tabBarItem.image = image
        }
        return navigationVC
    }
}
