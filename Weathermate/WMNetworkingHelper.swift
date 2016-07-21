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
    

    func retrieveWeather(city: String, completionHandler: (data: [WMWeatherResponseObject], error: NSError?) -> Void) -> Void {

//        func retrieveWeather(completionHandler: (data: [WMWeatherResponseObject], error: NSError?) -> Void) -> Void {


        let newURL = NSURL(string:newYahooQueryURL(city))

//        let requestURL = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22nome%2C%20ak%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")

        if let requestUrl = newURL {

            let getRequest = WMRequest(requestMethod: "GET", url: requestUrl)

            getRequest.performRequestWithHandler(
                { (success: Bool, object: AnyObject?) -> Void in

                    var objectArray = [WMWeatherResponseObject]()

                    if success {
                        if let dataSource = object!["query"] as? [String:AnyObject] {
                            if let forecastArray = dataSource["results"]?["channel"]??["item"]??["forecast"] as? [[String:AnyObject]] {

                                for dic in forecastArray {
                                    let newResponseObject = WMWeatherResponseObject(dictionary: dic)
                                    objectArray.append(newResponseObject)

                                }

                                if dataSource.isEmpty == false {
                                    completionHandler(data: objectArray, error: nil)
                                }
                            }else {
                                print("error retrieving forecasts ")

                                if dataSource["count"] as? Int == 0 {
                                    //user entered bad city input
                                    NSNotificationCenter.defaultCenter().postNotificationName("badCity", object: nil)

                                }
                            }
                        }else {
                            print("error retrieving dataSource")

                        }
                    }else{
                        print("error performing request")
                    }
                    
            })
        }

    }



    func newYahooQueryURL(city: String) -> String {

        //properly places the city in the query string, does not account for state
        var beginningString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22"
        var endingString = "%2C%20%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        let URL = beginningString + city + endingString
        return URL

    }





}
