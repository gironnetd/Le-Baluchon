//
//  WeatherRequest.swift
//  Le Baluchon
//
//  Created by damien on 11/07/2022.
//

import Foundation
import CoreLocation

struct WeatherRequest {
    var cityName: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
}
