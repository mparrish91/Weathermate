//
//  WMRequest.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//


import Foundation


final class WMRequest: NSObject {

    var requestMethod: String
    var URL: NSURL


    typealias WMRequestHandler = (success: Bool, object: AnyObject?) -> ()


    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()){

    }


    init(requestMethod: String, url: NSURL) {
        self.requestMethod = requestMethod
//        self.parameters = parameters
        self.URL = url

    }

    func preparedURLRequest() -> NSURLRequest {

        let preparedURLString = self.URL.absoluteString
        let preparedURL = NSURL(string: preparedURLString)
        let request = NSMutableURLRequest(URL: preparedURL!)
        request.HTTPMethod = self.requestMethod

        return request


    }

    func performRequestWithHandler(handler: WMRequestHandler) {

        let request = preparedURLRequest()
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        session.dataTaskWithRequest(request) {(responseData, response, error) ->  Void in
            if let data = responseData {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                    handler(success: true, object: json)
                }else {
                    print("error: \(error!.localizedDescription)")
                    handler(success: false, object: json)

                }
            }
            }.resume()
    }
    
}

