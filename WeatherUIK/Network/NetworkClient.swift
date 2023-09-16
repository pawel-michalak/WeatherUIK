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

struct NetworkClient {}

extension NetworkClient: CitySearchProtocol {
    func searchFor(city: String) async throws -> [CityData] {
        print("Started sleep")
        let encCity = city.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let url = URL(string: "https://dataservice.accuweather.com/locations/v1/cities/search?apikey=WG57ASHO2I73JrqtX1XZrWAZGvFdE4Ji&q=\(encCity)")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherAPIError.responseError
        }
        
        let decoder = JSONDecoder()
        let cities = try decoder.decode([CityData].self, from: data)
        
        print("This are cities: ", cities)
        print("Ended sleep")
        
        return cities
    }
}

extension NetworkClient: WeatherDataProtocol {
    func weatherDataFor(cityData: CityData) async throws -> WeatherData {
        let url = URL(string: "https://dataservice.accuweather.com/currentconditions/v1/\(cityData.Key)?apikey=WG57ASHO2I73JrqtX1XZrWAZGvFdE4Ji")!
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw WeatherAPIError.responseError
        }
        
        let decoder = JSONDecoder()
        let weather = try decoder.decode([WeatherData].self, from: data)
        
        print("This is weather: ", weather[0])
        print("Ended sleep")
        
        //Adjust this
        return weather[0]
    }
}
