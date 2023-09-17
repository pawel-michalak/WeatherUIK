//
//  DataModel.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 17/09/2023.
//

import Foundation

struct WeatherData: Codable {
    let WeatherText: String
    let WeatherIcon: Int
    let Temperature: TemperatureData
    
    var temperatureValue: Double {
        Temperature.Metric.Value
    }
    
    var temperatureDescription: String {
        return "\(Temperature.Metric.Value) \(Temperature.Metric.Unit)"
    }
}

struct TemperatureData: Codable {
    let Metric: MetricData
}

struct MetricData: Codable {
    let Value: Double
    let Unit: String
}

struct CityData: Codable, Equatable {
    let Key: String
    let LocalizedName: String
    let EnglishName: String
    let AdministrativeArea: AreasName
    let Country: AreasName
}

struct AreasName: Codable, Equatable {
    let LocalizedName: String
    let EnglishName: String
}
