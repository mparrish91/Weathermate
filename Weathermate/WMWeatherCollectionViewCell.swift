//
//  WMWeatherCollectionViewCell.swift
//  Weathermate
//
//  Created by parry on 7/20/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit




class WMWeatherCollectionViewCell: UICollectionViewCell {

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
//        contentView.addSubview(highLabel)
//        contentView.addSubview(lowLabel)
        contentView.addSubview(dateLabel)

        let margins = contentView.layoutMarginsGuide

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor, constant: 20).active = true
        dateLabel.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 5).active = true
        dateLabel.font = UIFont(name: "Avenir-Book", size: 14)
        dateLabel.textColor = UIColor.whiteColor()



        forecastImageView.translatesAutoresizingMaskIntoConstraints = false
        forecastImageView.topAnchor.constraintEqualToAnchor(dateLabel.bottomAnchor, constant: 5).active = true
        forecastImageView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 5).active = true
        forecastImageView.widthAnchor.constraintEqualToAnchor(nil, constant: 50).active = true
        forecastImageView.heightAnchor.constraintEqualToAnchor(nil, constant: 50).active = true




    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func layoutSubviews() {


    }




}
