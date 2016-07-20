//
//  WMUserInputViewController.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit

final class WMUserInputViewController: UIViewController, UITextFieldDelegate {

    private var locationTextField: UITextField
    private var progressView: UIProgressView
    private var titleLabel: UILabel
    private var submitButton: UIButton

    private var expectedContentLength = 0
    private var buffer:NSMutableData = NSMutableData()



    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }

    init?(_ coder: NSCoder? = nil) {
        self.locationTextField = UITextField()
        self.progressView = UIProgressView()
        self.titleLabel = UILabel()
        self.submitButton = UIButton()

        if let coder = coder {
            super.init(coder: coder)
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }
    }


    // MARK: UIViewController

  override func viewDidLoad() {
        super.viewDidLoad()
        let margins = view.layoutMarginsGuide
        view.backgroundColor = UIColor(netHex: 0xCEDEF1)


    titleLabel.text = "Weathermate"
    titleLabel.font = UIFont(name: "Avenir-Book", size: 36)
    titleLabel.textColor = UIColor.whiteColor()
    


    locationTextField.font = UIFont(name: "Avenir-Book", size: 20)
    locationTextField.textColor = UIColor.whiteColor()
    locationTextField.attributedPlaceholder = NSAttributedString(string:"Type here to enter your city..", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName :UIFont(name: "Avenir-Book", size: 20)!])
    locationTextField.textAlignment = .Center


    submitButton.setTitle("Submit", forState: .Normal)
    submitButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
    submitButton.layer.borderWidth = 0.0
    submitButton.titleLabel?.textColor = UIColor.whiteColor()

    progressView.progressTintColor = UIColor.yellowColor()
    progressView.trackTintColor = UIColor.whiteColor()

    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    titleLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor, constant: 100).active = true

    progressView.translatesAutoresizingMaskIntoConstraints = false
    progressView.topAnchor.constraintEqualToAnchor(titleLabel.layoutMarginsGuide.bottomAnchor, constant: 100).active = true
    progressView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20).active = true
    progressView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

    locationTextField.translatesAutoresizingMaskIntoConstraints = false
    locationTextField.topAnchor.constraintEqualToAnchor(progressView.bottomAnchor, constant: 100).active = true
    locationTextField.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20).active = true
    locationTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

    submitButton.hidden = true
    submitButton.translatesAutoresizingMaskIntoConstraints = false
    submitButton.topAnchor.constraintEqualToAnchor(locationTextField.layoutMarginsGuide.bottomAnchor, constant: 50).active = true
    submitButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
    submitButton.addTarget(self, action: #selector(onSubmitButtonPressed), forControlEvents: .TouchUpInside)




    }

    func onSubmitButtonPressed(sender: UIButton) {

        if let city = locationTextField.text {
            WMNetworkingHelper.sharedInstance.retrieveWeather(city) { (data, error) in

                if let weatherVC = WMWeatherCollectionViewController(forecasts: data) {
                    self.presentViewController(weatherVC, animated: true, completion: nil)
                }


            }

        }



    }

    //MARK: UITextFieldDelegate

    func textFieldDidBeginEditing(textField: UITextField) {
        submitButton.hidden = false

    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

    //MARK: NSURLSession

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {

        //here you can get full lenth of your content
        expectedContentLength = Int(response.expectedContentLength)
        print(expectedContentLength)
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {


        buffer.appendData(data)

        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
        progressView.progress =  percentageDownloaded
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        progressView.progress = 1.0   // download complete
    }



    override func loadView() {
        self.view = UIView()
        self.view.addSubview(locationTextField)
        self.view.addSubview(progressView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(submitButton)
    }

}
