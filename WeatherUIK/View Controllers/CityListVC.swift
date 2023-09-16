//
//  CityListVC.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 11/09/2023.
//

import UIKit

class CityListVC: UIViewController {
    
    let citiesArray: [CityData]
    let tableView = UITableView()
    let networkClient = NetworkClient()
    
    init(citiesArray: [CityData]) {
        self.citiesArray = citiesArray
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(CityTVCell.self, forCellReuseIdentifier: CityTVCell.reusableID)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        navigationController?.navigationBar.topItem?.backButtonTitle = "Search"
        view.backgroundColor = .white
        title = "Cities found"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
}

extension CityListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CityTVCell.reusableID) as! CityTVCell
        let city = citiesArray[indexPath.row]
        cell.set(cityData: city)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Move to another VC here
        Task {
            networkClient.searchFor(city:)
        }
        
        let detailsVC = WeatherDetailVC(cityData: citiesArray[indexPath.row])
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

class CityTVCell: UITableViewCell {
    
    static let reusableID = "CityCell"
    // FIXME: rename
    let textView = UILabel()
    
    func set(cityData: CityData) {
        textView.text = """
            \(cityData.EnglishName), \(cityData.AdministrativeArea.EnglishName)
            \(cityData.Country.EnglishName)
        """
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CityTVCell.reusableID)
        
        addSubview(textView)
        textView.numberOfLines = 0
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .boldSystemFont(ofSize: 20)
        
        let padding: CGFloat = 24
        
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            textView.widthAnchor.constraint(equalToConstant: 300),
            textView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
