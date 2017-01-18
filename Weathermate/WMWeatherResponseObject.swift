//
//  WMWeatherResponseObject.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import Foundation

final class WMWeatherResponseObject: NSObject {

    var newDate: String?
    var date : String?
    var high : String?
    var low : String?
    var forecast: String?

    init(dictionary: [String:AnyObject]) {
        super.init()

        high = dictionary["high"] as? String
        low = dictionary["low"] as? String
        forecast = dictionary["text"] as? String
        date = dictionary["date"] as? String
        if let date2 = date {
            self.setConvertedDate(date2)
        }
    }


    func setConvertedDate(_ dateString: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let dateObject = dateFormatter.date(from: dateString) {

            dateFormatter.dateFormat = "M.dd"
            self.newDate = dateFormatter.string(from: dateObject)

        }else{
            self.newDate = ""
        }

    }


}
