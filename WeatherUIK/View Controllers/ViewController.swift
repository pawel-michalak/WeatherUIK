//
//  ViewController.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 08/09/2023.
//

import UIKit

class ViewController: UIViewController {

    let textView = UITextView()
    let cityInputView = UITextField()
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
        
        cityInputView.backgroundColor = .secondarySystemFill
        cityInputView.borderStyle = .roundedRect
        cityInputView.textColor = .black
        cityInputView.autocorrectionType = .no
        cityInputView.autocapitalizationType = .none
        cityInputView.placeholder = "Type city name"
        cityInputView.translatesAutoresizingMaskIntoConstraints = false
        cityInputView.delegate = self
        
        //FIXME: add regex
        
        button.setTitle("Check weather", for: .normal)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 5
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(searchCityTapped), for: .touchUpInside)

        view.addSubview(cityInputView)
        view.addSubview(button)
        print("added subview")
        
        NSLayoutConstraint.activate([
            cityInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityInputView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cityInputView.widthAnchor.constraint(equalToConstant: 300),
            cityInputView.heightAnchor.constraint(equalToConstant: 44),
            
            button.topAnchor.constraint(equalTo: cityInputView.bottomAnchor, constant: 10),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])

    }
    
    @objc func searchCityTapped() {
        Task {
            guard let text = cityInputView.text else { return }
            do {
                let cities = try await searchFor(city: text)
                if cities.isEmpty {
                    //Here show alert
                }
                await MainActor.run {
                    let listVC = CityListVC(citiesArray: cities)
                    navigationController?.pushViewController(listVC, animated: true)
                }
            } catch {
                print("Something went wrong: ", error)
            }
        }
    }
    

    
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


extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        // Wielkie litery
        let regex = "[[:alpha:]]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: string)
    }
}

enum WeatherAPIError: Error {
    case responseError
}

struct WeatherData: Codable {
    let WeatherText: String
    let WeatherIcon: Int
    let Temperature: TemperatureData
}

struct TemperatureData: Codable {
    let Metric: MetricData
}

struct MetricData: Codable {
    let Value: Double
    let Unit: String
}

struct CityData: Codable {
    let Key: String
    let LocalizedName: String
    let EnglishName: String
    let AdministrativeArea: AreasName
    let Country: AreasName
}

struct AreasName: Codable {
    let LocalizedName: String
    let EnglishName: String
}

