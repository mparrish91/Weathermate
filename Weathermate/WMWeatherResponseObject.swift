//
//  WMWeatherResponseObject.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import Foundation

class WMWeatherResponseObject: NSObject {

    var date : String
    var high : String
    var low : String
    var forecast: String


    init(date: String, high: String, low: String, forecast: String) {

        self.date = date
        self.high = high
        self.low = low
        self.forecast = forecast

        super.init()

    }


}
