//
//  SearchVC.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 08/09/2023.
//

import UIKit

class SearchVC: UIViewController {

    var networkClient = NetworkClient()
    var persisstanceClient = PersistanceClient()
    
    let activityView = UIActivityIndicatorView(style: .medium)
    
    let titleTextView = UITextView()
    let cityInputView = UITextField()
    let searchButton = UIButton()
    
    let tableView = UITableView()
    
    let backgroundImageView = UIImageView()
    
    var recentCities = [CityData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTitleTextView()
        configureCityInputView()
        configureSearchButton()
        
        configureTableView()
        
        configureBackgroundImage()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let recents = try? persisstanceClient.getRecents() {
            recentCities = recents
        }
        tableView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityView)
    }
    
    func configureTitleTextView() {
        view.addSubview(titleTextView)
        
        titleTextView.text = "What's the weather in..."
        titleTextView.font = .systemFont(ofSize: 26)
        titleTextView.textColor = .black
        titleTextView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configureCityInputView() {
        view.addSubview(cityInputView)
        cityInputView.backgroundColor = .secondarySystemFill
        cityInputView.borderStyle = .roundedRect
        cityInputView.textColor = .black
        cityInputView.font = .systemFont(ofSize: 20)
        cityInputView.autocorrectionType = .no
        cityInputView.autocapitalizationType = .none
        cityInputView.placeholder = "Type city name"
        cityInputView.clearButtonMode = .whileEditing
        cityInputView.translatesAutoresizingMaskIntoConstraints = false
        
        cityInputView.delegate = self
    }
    
    func configureSearchButton() {
        view.addSubview(searchButton)
        searchButton.setTitle("Check", for: .normal)
        searchButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        searchButton.backgroundColor = .systemGreen
        searchButton.layer.cornerRadius = 10
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        
        searchButton.addTarget(self, action: #selector(searchCityTapped), for: .touchUpInside)
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        
        tableView.rowHeight = 30
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(RecentCell.self, forCellReuseIdentifier: RecentCell.reusableID)
    }
    
    func configureBackgroundImage() {
        view.addSubview(backgroundImageView)
        
        let backgroundImage = UIImage(named: "background")
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextView.widthAnchor.constraint(equalToConstant: 300),
            titleTextView.heightAnchor.constraint(equalToConstant: 44),
            
            cityInputView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cityInputView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20),
            cityInputView.widthAnchor.constraint(equalToConstant: 300),
            cityInputView.heightAnchor.constraint(equalToConstant: 44),
            
            searchButton.topAnchor.constraint(equalTo: cityInputView.bottomAnchor, constant: 10),
            searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchButton.widthAnchor.constraint(equalToConstant: 150),
            searchButton.heightAnchor.constraint(equalToConstant: 64),
            
            tableView.topAnchor.constraint(equalTo: searchButton.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
            
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            backgroundImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
        ])
    }
    
    @objc func searchCityTapped() {
        guard let text = cityInputView.text, !text.isEmpty else { return }
        
        setLoading(isLoading: true)
        defer { setLoading(isLoading: false) }
        
        Task {
            do {
                let cities = try await networkClient.searchFor(city: text)
                await MainActor.run {
                    let listVC = CityListVC(citiesArray: cities)
                    navigationController?.pushViewController(listVC, animated: true)
                }
            } catch WeatherAPIError.responseError {
                presentErrorAlert(error: .responseError)
            } catch WeatherAPIError.noDataFound {
                presentErrorAlert(error: .noDataFound)
            } catch {
                print("Something went wrong: ", error)
            }
        }
    }
    
    @MainActor
    func setLoading(isLoading: Bool) {
        if isLoading {
            activityView.startAnimating()
            searchButton.isEnabled = false
            searchButton.layer.opacity = 0.5
        } else {
            activityView.stopAnimating()
            searchButton.isEnabled = true
            searchButton.layer.opacity = 1.0
        }
    }
    
    @MainActor
    func presentErrorAlert(error: WeatherAPIError) {
        let title: String
        let message: String
        
        switch error {
        case .noDataFound:
            title = "No data"
            message = "Cannot find typed city :("
        case .responseError:
            title = "Response error"
            message = "There was a problem with getting results"
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        navigationController?.present(alertController, animated: true)
    }
}

extension SearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentCell.reusableID) as! RecentCell
        let city = recentCities[indexPath.row]
        cell.set(cityData: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Your recent search: "
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        activityView.startAnimating()

        Task { [cities = recentCities] in
            let weatherData = try await networkClient.weatherDataFor(cityData: cities[indexPath.row])
            await MainActor.run {
                let weatherDetailsVC = WeatherDetailVC(weatherData: weatherData)
                navigationController?.pushViewController(weatherDetailsVC, animated: true)
                activityView.stopAnimating()
            }
        }
    }
}

extension SearchVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        
        let regex = "[[:alpha:]]{1,}"
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: string)
    }
}
