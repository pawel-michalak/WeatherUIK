//
//  CityCell.swift
//  WeatherUIK
//
//  Created by Paweł Michalak on 17/09/2023.
//

import UIKit

class CityCell: UITableViewCell {
    
    static let reusableID = "CityCell"
    let textView = UILabel()
    
    func set(cityData: CityData) {
        textView.text =
        """
            \(cityData.EnglishName), \(cityData.AdministrativeArea.EnglishName)
            \(cityData.Country.EnglishName)
        """
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: CityCell.reusableID)
        
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

