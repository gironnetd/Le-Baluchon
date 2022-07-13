//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by damien on 11/07/2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var localCityWeather: CityWeatherView!
    
    @IBOutlet weak var selectedCityWeather: CityWeatherView!
    private var selectedCityName: String = "New York"
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1] as CLLocation
        WeatherService.shared.retrieveData(
            from: WeatherRequest(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), callBack: { [self] result, error in
                if let result = result {
                    localCityWeather.cityName.text = result.name
                    localCityWeather.weatherDescription.text = result.weather[0].weatherDescription
                    localCityWeather.temp.text = String(result.main.temp)
                    localCityWeather.minTemp.text = String(result.main.tempMin)
                    localCityWeather.maxTemp.text = String(result.main.tempMax)
                    localCityWeather.icon.image = UIImage(data: result.weather[0].iconImage!)
                    localCityWeather.humidity.text = String(result.main.humidity)
                    localCityWeather.visibility.text = String(result.visibility)
                    
                    findSelectedCityWeather()
                }

                self.locationManager.stopUpdatingLocation()
        })
    }
    
    func findSelectedCityWeather() {
        WeatherService.shared.retrieveData(
            from: WeatherRequest(cityName: selectedCityName), callBack: { [self] result, error in
                if let result = result {
                    selectedCityWeather.cityName.text = selectedCityName
                    selectedCityWeather.weatherDescription.text = result.weather[0].weatherDescription
                    selectedCityWeather.temp.text = String(result.main.temp)
                    selectedCityWeather.minTemp.text = String(result.main.tempMin)
                    selectedCityWeather.maxTemp.text = String(result.main.tempMax)
                    selectedCityWeather.icon.image = UIImage(data: result.weather[0].iconImage!)
                    selectedCityWeather.humidity.text = String(result.main.humidity)
                    selectedCityWeather.visibility.text = String(result.visibility)
                }
        })
    }
}
