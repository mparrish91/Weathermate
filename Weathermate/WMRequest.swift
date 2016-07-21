//
//  WMRequest.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//


import UIKit


final class WMRequest: NSObject {

    var requestMethod: String
    var URL: NSURL


    typealias WMRequestHandler = (success: Bool, object: AnyObject?) -> ()


    private func dataTask(request: NSMutableURLRequest, method: String, completion: (success: Bool, object: AnyObject?) -> ()){

    }


    init(requestMethod: String, url: NSURL) {
        self.requestMethod = requestMethod
        self.URL = url

    }

    func preparedURLRequest() -> NSURLRequest {

        let preparedURLString = self.URL.absoluteString
        let preparedURL = NSURL(string: preparedURLString)
        let request = NSMutableURLRequest(URL: preparedURL!)
        request.HTTPMethod = self.requestMethod
        request.setValue("", forHTTPHeaderField: "Accept-Encoding")

        return request


    }

    func performRequestWithHandler(handler: WMRequestHandler) {

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let delegate = appDelegate.returnRootVC() as? NSURLSessionDelegate

        if let vc = delegate as? WMUserInputViewController {
            vc.handler = handler
        }

        let request = preparedURLRequest()

        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let manqueue = NSOperationQueue.mainQueue()
        let session = NSURLSession(configuration: configuration, delegate:delegate, delegateQueue: manqueue)


        let task = session.dataTaskWithRequest(request)
//        let task = session.dataTaskWithRequest(request) {(responseData, response, error) ->  Void in
//            if let data = responseData {
//                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
//                if let response = response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
//                    handler(success: true, object: json)
//                }else {
//                    print("error: \(error!.localizedDescription)")
//                    handler(success: false, object: json)
//
//                }
//            }
//            }
        task.resume()

    }


}

