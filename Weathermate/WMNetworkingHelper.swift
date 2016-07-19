//
//  WMNetworkingHelper.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import Foundation



final class WMNetworkingHelper: NSObject {
    static let sharedInstance = WMNetworkingHelper()
    

        func retrieveWeather(completionHandler: (data: [WMWeatherResponseObject], error: NSError?) -> Void) -> Void {

            //for tweets with #thisBrick
            let requestURL = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")

            let getRequest = WMRequest(requestMethod: "GET", url: requestURL!)


            getRequest.performRequestWithHandler(
                { (success: Bool, object: AnyObject?) -> Void in

                    var objectArray = [WMWeatherResponseObject]()
                    var date = String()
                    var high = String()
                    var low = String()
                    var forecast = String()

                    if success {
                        let dataSource = object!["query"] as! [String:AnyObject]
                        let forecastArray = dataSource["results"]!["channel"]!!["item"]!!["forecast"] as! [[String:AnyObject]]

                        for dic in forecastArray {
                            high = dic["high"] as! String
                            low = dic["low"] as! String
                            forecast = dic["text"] as! String
                            date = dic["date"] as! String
                            let newResponseObject = WMWeatherResponseObject(date: date, high: high, low: low, forecast: forecast)
                            objectArray.append(newResponseObject)

                        }

                        if dataSource.isEmpty == false {
                            completionHandler(data: objectArray, error: nil)
                        }

                    }else {
                        print("error")

                    }


            })

    }






}
