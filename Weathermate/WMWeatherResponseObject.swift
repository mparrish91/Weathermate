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

    init(dictionary: [String:AnyObject]) {
        high = dictionary["high"] as? String ?? ""
        low = dictionary["low"] as? String ?? ""
        forecast = dictionary["text"] as? String ?? ""
        date = dictionary["date"] as? String ?? ""
    }




}
