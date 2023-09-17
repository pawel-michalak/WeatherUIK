//
//  WeatherDetailVC.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 10/09/2023.
//

import UIKit

class WeatherDetailVC: UIViewController {
    
    var weather: WeatherData
    var forecast: [WeatherForecastData]?
    var cityData: CityData

    let closeButton = UIButton()
    let dateTextView = UITextView()
    let cityTextView = UITextView()
    let temperatureTextView = UITextView()
    let networkClient = NetworkClient()
    
    init(weatherData: WeatherData, weatherForecast: [WeatherForecastData]?, cityData: CityData) {
        self.weather = weatherData
        self.forecast = weatherForecast
        self.cityData = cityData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCloseButton()
        setupDateTextView()
        setupCityTextView()
        setupTemperatureInfo()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupDateTextView() {
        view.addSubview(dateTextView)
        
        dateTextView.text = weather.dateForWeather
        dateTextView.font = .preferredFont(forTextStyle: .title1)
        dateTextView.textColor = .black
        dateTextView.translatesAutoresizingMaskIntoConstraints = false
        dateTextView.textAlignment = .center
    }
    
    func setupCityTextView() {
        view.addSubview(cityTextView)

        cityTextView.text = cityData.EnglishName
        cityTextView.font = .preferredFont(forTextStyle: .largeTitle)
        cityTextView.textColor = .black
        cityTextView.translatesAutoresizingMaskIntoConstraints = false
        cityTextView.textAlignment = .center
    }
        
    func setupTemperatureInfo() {
        view.addSubview(temperatureTextView)
        
        temperatureTextView.text = weather.temperatureDescription
        temperatureTextView.font = .preferredFont(forTextStyle: .largeTitle)
        temperatureTextView.textColor = .white
        temperatureTextView.translatesAutoresizingMaskIntoConstraints = false
        temperatureTextView.textAlignment = .center
        
        switch weather.temperatureValue {
        case _ where weather.temperatureValue < 10:
            temperatureTextView.textColor = .systemBlue
        case 10 ... 20:
            temperatureTextView.textColor = .black
        case _ where weather.temperatureValue > 20:
            temperatureTextView.textColor = .systemRed
        default:
            temperatureTextView.backgroundColor = .white
        }
    }
    
    func setupCloseButton() {
        let image: UIImage = .init(systemName: "xmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))!
        
        view.addSubview(closeButton)
        
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.tintColor = .black
        closeButton.layer.cornerRadius = 5
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 60),
            closeButton.heightAnchor.constraint(equalToConstant: 60),
            
            dateTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            dateTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            dateTextView.heightAnchor.constraint(equalToConstant: 60),
            dateTextView.widthAnchor.constraint(equalToConstant: 200),
            
            cityTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityTextView.topAnchor.constraint(equalTo: dateTextView.bottomAnchor),
            cityTextView.heightAnchor.constraint(equalToConstant: 60),
            cityTextView.widthAnchor.constraint(equalToConstant: 200),
            
            temperatureTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureTextView.topAnchor.constraint(equalTo: cityTextView.bottomAnchor, constant: 100),
            temperatureTextView.heightAnchor.constraint(equalToConstant: 120),
            temperatureTextView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    @objc func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
