//
//  WMWeatherCollectionViewCell.swift
//  Weathermate
//
//  Created by parry on 7/20/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit


struct MyIcon {
    static let plane = Icon.plane(img: UIImage(named: "image.png")!, col: UIColor.blueColor())
    static let arrow = Icon.arrow(img: UIImage(named: "image.png")!, col: UIColor.blueColor())
    static let logo = Icon.logo(img: UIImage(named: "image.png")!, col: UIColor.blueColor())
    static let flag = Icon.flag(img: UIImage(named: "image.png")!, col: UIColor.blueColor())
}



class WMWeatherCollectionViewCell: UICollectionViewCell {

    private var forecastImageView: UIImageView
    private var highLabel: UILabel
    private var lowLabel: UILabel
    private var dateLabel: UILabel

    override init(frame: CGRect) {
        self.forecastImageView = UIImageView()
        self.highLabel = UILabel()
        self.lowLabel = UILabel()
        self.dateLabel = UILabel()

        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func layoutSubviews() {
        self.contentView.addSubview(forecastImageView)
        self.contentView.addSubview(highLabel)
        self.contentView.addSubview(lowLabel)
        self.contentView.addSubview(dateLabel)


    }




}
