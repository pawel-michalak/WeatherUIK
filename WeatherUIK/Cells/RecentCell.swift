//
//  RecentCell.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 17/09/2023.
//

import UIKit

class RecentCell: UITableViewCell {
    
    static let reusableID = "RecentCell"
    let textView = UILabel()
    
    func set(cityData: CityData) {
        textView.text = "\(cityData.EnglishName), \(cityData.AdministrativeArea.EnglishName), \(cityData.Country.EnglishName)"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: RecentCell.reusableID)
        
        addSubview(textView)
        textView.numberOfLines = 1
        textView.textColor = .black
        textView.backgroundColor = .clear
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            textView.widthAnchor.constraint(equalToConstant: 300),
            textView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


