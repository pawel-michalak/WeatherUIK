//
//  DataModel.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 17/09/2023.
//

import Foundation

struct WeatherData: Codable {
    let EpochTime: Double
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

extension WeatherData {
    var dateForWeather: String {
        let date = Date(timeIntervalSince1970: EpochTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d.MM"
        return formatter.string(from: date)
    }
}

struct WeatherForecastData: Codable {
    let DailyForecasts: DailyForecasts
}

struct DailyForecasts: Codable {
    let EpochDate: Double
    let Temperature: Temperature
}

struct Temperature: Codable {
    let Minimum: TemperatureValue
    let Maximum: TemperatureValue
}

struct TemperatureData: Codable {
    let Metric: TemperatureValue
}

struct TemperatureValue: Codable {
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
