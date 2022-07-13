//
//  WeatherService.swift
//  Le Baluchon
//
//  Created by damien on 11/07/2022.
//

import Foundation
import CoreLocation

final class WeatherService: ApiService {
    
    static var shared: WeatherService = WeatherService()
    
    private init(){}
    
    internal var session: URLSession = URLSession(configuration: .default)
    private var iconSession: URLSession = URLSession(configuration: .default)
    
    init(session: URLSession, iconSession: URLSession) {
        self.session = session
        self.iconSession = iconSession
    }
    
    typealias DataRequest = WeatherRequest
    typealias CallBackResponse = WeatherResponse
    typealias DataResponse = WeatherResponse
    
    private var cityName: Parameter = Parameter(key: "q")
    private var latitude: Parameter = Parameter(key: "lat")
    private var longitude: Parameter = Parameter(key: "lon")
    
    var parameters: [Parameter] {
        [cityName, latitude, longitude, apiKey(keyPlist: "WeatherApiKey", keyParameter: "appid")]
    }
    
    var httpMethod: HttpMethod { HttpMethod.get }
    
    var host: String { "api.openweathermap.org" }
    var path: String  {
        get {
            if endPoint == WeatherEndPoint.weather.rawValue {
                return "/data/2.5/" + endPoint
            }
            return endPoint
        }
        set {}
    }
    var endPoint: String = WeatherEndPoint.weather.rawValue
    
    internal var task: URLSessionDataTask?
    
    internal func populateParameters(dataRequest: WeatherRequest) {
        self.cityName.value = dataRequest.cityName
        if let latitude = dataRequest.latitude, let longitude = dataRequest.longitude {
            self.latitude.value = String(latitude)
            self.longitude.value = String(longitude)
        }
    }
    
    func retrieveData(from dataRequest: WeatherRequest, callBack: @escaping (WeatherResponse?, NetworkError?) -> Void) {
        self.endPoint = WeatherEndPoint.weather.rawValue
        populateParameters(dataRequest: dataRequest)
        
        task?.cancel()
        task = retrieveTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let networkError = handleError(data: data, response: response, error: error) {
                    callBack(nil, networkError)
                    return
                }
                
                guard let weatherResponse = data else {
                    return
                }
                
                retrieveWeatherIcon(weather: weatherResponse, callBack: { response, error in
                    guard error == nil else {
                        callBack(weatherResponse, nil)
                        return
                    }
                    callBack(response, nil)
                })
            }
        }
        task?.resume()
    }
    
    func retrieveWeatherIcon(weather: WeatherResponse, callBack: @escaping (WeatherResponse?, NetworkError?) -> Void) {
        self.cityName.value = nil
        self.latitude.value = nil
        self.longitude.value = nil
        
        self.endPoint = WeatherEndPoint.icon.rawValue + weather.weather[0].icon + ".png"
        
        task?.cancel()
        task = iconSession.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async { [self] in
                if let networkError = handleError(data: nil, response: response, error: error) {
                    callBack(nil, networkError)
                    return
                }
                
                var weatherResponse = weather
                
                if let data = data {
                    weatherResponse.weather[0].iconImage = data
                }
                callBack(weatherResponse, nil)
            }
        }
        task?.resume()
    }
}
