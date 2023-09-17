//
//  CityListVC.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 11/09/2023.
//

import UIKit

class CityListVC: UIViewController {
    
    var networkClient = NetworkClient()
    var persistanceClient = PersistanceClient()
    
    let citiesArray: [CityData]
    let tableView = UITableView()
    let activityView = UIActivityIndicatorView(style: .medium)
    
    init(citiesArray: [CityData]) {
        self.citiesArray = citiesArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityView)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.backButtonTitle = "Search"
        navigationController?.navigationBar.isHidden = false
        title = "Cities found"
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.reusableID)
    }
}

extension CityListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.reusableID) as! CityCell
        let city = citiesArray[indexPath.row]
        cell.set(cityData: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityView.startAnimating()
        
        Task {
            persistanceClient.add(cityData: citiesArray[indexPath.row])
        }
        Task {
            async let weatherData = networkClient.weatherDataFor(cityData: citiesArray[indexPath.row])
            async let weatherForecastData = networkClient.weatherForecastFor(cityData: citiesArray[indexPath.row])
            
            let (weather, forecast) = (try await weatherData, try? await weatherForecastData)
            await MainActor.run {
                let weatherDetailsVC = WeatherDetailVC(weatherData: weather, weatherForecast: forecast, cityData: citiesArray[indexPath.row])
                navigationController?.pushViewController(weatherDetailsVC, animated: true)
                activityView.stopAnimating()
            }
        }
    }
}
