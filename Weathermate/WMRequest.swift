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
    var URL: Foundation.URL

    typealias WMRequestHandler = (_ success: Bool, _ object: AnyObject?) -> ()


    init(requestMethod: String, url: Foundation.URL) {
        self.requestMethod = requestMethod
        self.URL = url

    }

    func preparedURLRequest() -> URLRequest {

        let preparedURLString = self.URL.absoluteString
        let preparedURL = Foundation.URL(string: preparedURLString)
        let request = NSMutableURLRequest(url: preparedURL!)
        request.httpMethod = self.requestMethod

        return request as URLRequest


    }

    func performRequestWithHandler(_ handler: @escaping WMRequestHandler) {

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let delegate = appDelegate.returnRootVC() as? URLSessionDelegate

        if let vc = delegate as? WMUserInputViewController {
            vc.handler = handler
        }

        let request = preparedURLRequest()
        let configuration = URLSessionConfiguration.default
        let manqueue = OperationQueue.main
        let session = URLSession(configuration: configuration, delegate:delegate, delegateQueue: manqueue)

        let task = session.dataTask(with: request)
        task.resume()

    }


}

