//
//  WMWeatherCollectionViewCell.swift
//  Weathermate
//
//  Created by parry on 7/20/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit




final class WMWeatherCollectionViewCell: UICollectionViewCell {

    var forecastImageView: UIImageView
    var highLabel: UILabel
    var lowLabel: UILabel
    var dateLabel: UILabel

    override init(frame: CGRect) {

        self.forecastImageView = UIImageView()
        self.highLabel = UILabel()
        self.lowLabel = UILabel()
        self.dateLabel = UILabel()

        super.init(frame: frame)

        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true

        contentView.addSubview(forecastImageView)
        contentView.addSubview(highLabel)
        contentView.addSubview(lowLabel)
        contentView.addSubview(dateLabel)

        let margins = contentView.layoutMarginsGuide

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3).isActive = true
        dateLabel.font = UIFont(name: "Avenir-Book", size: 14)
        dateLabel.textColor = UIColor.white


        forecastImageView.translatesAutoresizingMaskIntoConstraints = false
        forecastImageView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        forecastImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3).isActive = true
        
        //forecastImageView.widthAnchor.constraint(equalTo: nil, constant: 40).isActive = true
        //forecastImageView.heightAnchor.constraint(equalTo: nil, constant: 40).isActive = true
        forecastImageView.contentMode = .scaleAspectFit

        highLabel.translatesAutoresizingMaskIntoConstraints = false
        highLabel.topAnchor.constraint(equalTo: forecastImageView.bottomAnchor, constant: 5).isActive = true
        highLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3).isActive = true
        highLabel.font = UIFont(name: "Avenir-Book", size: 14)
        highLabel.textColor = UIColor.white

        lowLabel.translatesAutoresizingMaskIntoConstraints = false
        lowLabel.topAnchor.constraint(equalTo: highLabel.bottomAnchor, constant: 5).isActive = true
        lowLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 3).isActive = true
        lowLabel.font = UIFont(name: "Avenir-Book", size: 14)
        lowLabel.textColor = UIColor.white


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




}
