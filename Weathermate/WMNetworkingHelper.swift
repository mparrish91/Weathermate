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
    

    func retrieveWeather(_ city: String, completionHandler: @escaping (_ data: [WMWeatherResponseObject], _ error: NSError?) -> Void) -> Void {

        let newURL = URL(string:newYahooQueryURL(city))

        if let requestUrl = newURL {

            let getRequest = WMRequest(requestMethod: "GET", url: requestUrl)

            getRequest.performRequestWithHandler(
                { (success: Bool, object: AnyObject?) -> Void in

                    var objectArray = [WMWeatherResponseObject]()

                    if success {
                            if let dataSource = object?["query"] as? [String:AnyObject]
                            {
                                
                                let p1 = dataSource["results"] as? [String:AnyObject]
                                let p2 = p1?["channel"] as? [String:AnyObject]
                                let p3 = p2?["item"] as? [String:AnyObject]
                                let forecastArray = p3?["forecast"] as? [[String:AnyObject]]
                        
                                for dic in forecastArray! {
                                    let newResponseObject = WMWeatherResponseObject(dictionary: dic)
                                    objectArray.append(newResponseObject)

                                }

                                if dataSource.isEmpty == false {
                                    completionHandler(objectArray, nil)
                                }
                            }else if let dataSource = object?["query"] as? [String:AnyObject] {
                                print("error retrieving forecasts ")

                                if dataSource["count"] as? Int == 0 {
                                    //user entered bad city input
                                    NotificationCenter.default.post(name: Notification.Name(rawValue: "badCity"), object: nil)

                                }
                            }
                            else {
                                NotificationCenter.default.post(name: Notification.Name(rawValue: "badRequest"), object: nil)

                        }

                    }else{
                        print("error performing request")
                    }
                    
            })
        }

    }



    func newYahooQueryURL(_ city: String) -> String {

        //properly places the city in the query string, does not account for state
        let beginningString = "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22"
        let endingString = "%2C%20%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
        let URL = beginningString + city + endingString
        return URL

    }





}
