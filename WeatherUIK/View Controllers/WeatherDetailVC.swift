//
//  WeatherDetailVC.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 10/09/2023.
//

import UIKit

class WeatherDetailVC: UIViewController {
    
    var weather: WeatherData

    let closeButton = UIButton()
    let temperatureTextView = UITextView()
    let networkClient = NetworkClient()
    
    init(weatherData: WeatherData) {
        self.weather = weatherData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupCloseButton()
        setupTemperatureInfo()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
            
            temperatureTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            temperatureTextView.heightAnchor.constraint(equalToConstant: 200),
            temperatureTextView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    @objc func closeButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
