//
//  NetworkClient.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 16/09/2023.
//

import Foundation

protocol CitySearchProtocol {
    func searchFor(city: String) async throws -> [CityData]
}

protocol WeatherDataProtocol {
    func weatherDataFor(cityData: CityData) async throws -> WeatherData
}

struct NetworkClient {
    private let API_KEY = "L6Tf6KQvFJI3I5qnj9hjxnF0qcAbepf4"
}

enum WeatherAPIError: Error {
    case responseError, noDataFound
}

extension NetworkClient: CitySearchProtocol {
    func searchFor(city: String) async throws -> [CityData] {
        guard !API_KEY.isEmpty else { fatalError("Please provide API KEY") }
        
        let encCity = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let url = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=\(API_KEY)&q=\(encCity)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherAPIError.responseError
        }
        
        let cities = try JSONDecoder().decode([CityData].self, from: data)
        
        guard !cities.isEmpty else {
            throw WeatherAPIError.noDataFound
        }
        
        print("This are cities: ", cities)
        
        return cities
    }
}

extension NetworkClient: WeatherDataProtocol {
    func weatherDataFor(cityData: CityData) async throws -> WeatherData {
        guard !API_KEY.isEmpty else { fatalError("Please provide API KEY") }
        let url = URL(string: "https://dataservice.accuweather.com/currentconditions/v1/\(cityData.Key)?apikey=\(API_KEY)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherAPIError.responseError
        }
        
        let weatherArray = try JSONDecoder().decode([WeatherData].self, from: data)
        
        guard !weatherArray.isEmpty else {
            throw WeatherAPIError.noDataFound
        }
        
        print("This is weather: ", weatherArray[0])
        
        return weatherArray[0]
    }
}
