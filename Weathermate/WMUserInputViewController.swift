//
//  WMUserInputViewController.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit

final class WMUserInputViewController: UIViewController, UITextFieldDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate {

    private var locationTextField: UITextField
    private var progressView: UIProgressView
    private var titleLabel: UILabel
    private var submitButton: UIButton

    private var expectedContentLength = 0
    private var buffer:NSMutableData = NSMutableData()

    private var currentDeviceOrientation: UIDeviceOrientation = .Unknown


    var handler: ((success: Bool, object: AnyObject?) -> ())?

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
        view.backgroundColor = UIColor(netHex: 0xCEDEF1)

    titleLabel.text = "Weathermate"
    titleLabel.font = UIFont(name: "Avenir-Book", size: 36)
    titleLabel.textColor = UIColor.whiteColor()

    locationTextField.font = UIFont(name: "Avenir-Book", size: 20)
    locationTextField.textColor = UIColor.whiteColor()
    locationTextField.attributedPlaceholder = NSAttributedString(string:"Type here to enter your city..", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName :UIFont(name: "Avenir-Book", size: 20)!])
    locationTextField.textAlignment = .Center
    locationTextField.delegate = self

    submitButton.setTitle("Submit", forState: .Normal)
    submitButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
    submitButton.layer.borderWidth = 0.0
    submitButton.titleLabel?.textColor = UIColor.whiteColor()

    progressView.progressTintColor = UIColor.yellowColor()
    progressView.trackTintColor = UIColor.whiteColor()

    submitButton.hidden = true
    submitButton.addTarget(self, action: #selector(onSubmitButtonPressed), forControlEvents: .TouchUpInside)

    setPotraitLayout()

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WMUserInputViewController.presentBadInputAlert), name: "badCity", object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WMUserInputViewController.presentBadRequestAlert), name: "badRequest", object: nil)

    }


    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        NSNotificationCenter.defaultCenter().removeObserver(self)
        if UIDevice.currentDevice().generatesDeviceOrientationNotifications {
            UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        progressView.progress = 0

        //device rotation
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceDidRotate:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        self.currentDeviceOrientation = UIDevice.currentDevice().orientation
            }


    override func loadView() {
        self.view = UIView()
        self.view.addSubview(locationTextField)
        self.view.addSubview(progressView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(submitButton)
    }

    


    func deviceDidRotate(notification: NSNotification) {
        let currentOrientation = UIDevice.currentDevice().orientation

        // Ignore changes in device orientation if unknown, face up, or face down.
        if !UIDeviceOrientationIsValidInterfaceOrientation(currentOrientation) {
            return;
        }

        let isLandscape = UIDeviceOrientationIsLandscape(currentOrientation);

        if isLandscape {
            setRotatedLayout()

        }else{
            setPotraitLayout()
        }
    }

      func onSubmitButtonPressed(sender: UIButton) {

        if let city = locationTextField.text {
            WMNetworkingHelper.sharedInstance.retrieveWeather(city.removeWhitespace()) { (data, error) in

                if let weatherVC = WMWeatherCollectionViewController(forecasts: data) {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentViewController(weatherVC, animated: true, completion: nil)
                    })
                }


            }

        }



    }

    func presentBadInputAlert() {
        //reset the progress view
        progressView.progress = 0

        let alertController = UIAlertController(title: nil, message: "oops looks like that city is not supported", preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
        }))

        presentViewController(alertController, animated: true, completion: nil)
        
    }

    func presentBadRequestAlert() {
        //reset the progress view
        progressView.progress = 0

        let alertController = UIAlertController(title: nil, message: "oops something went wrong. Please try again", preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
        }))

        presentViewController(alertController, animated: true, completion: nil)
        
    }

    //MARK: UITextFieldDelegate

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 0 {
            submitButton.hidden = false

        }
        return true
    }


    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


    //MARK: NSURLSession

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveResponse response: NSURLResponse, completionHandler: (NSURLSessionResponseDisposition) -> Void) {

        expectedContentLength = Int(response.expectedContentLength)
        print(expectedContentLength)
        completionHandler(NSURLSessionResponseDisposition.Allow)
    }

    func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {

        buffer.appendData(data)

        //want to look into more/ hack for showing download progress. because expected length always -1 currently

//        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
//        progressView.progress =  percentageDownloaded


        var progress: Float!

        if expectedContentLength < 0 {
            progress = (Float(buffer.length) % 10_000_000.0) / 10_000_000.0
        } else {
            progress = Float(buffer.length) / Float(expectedContentLength)
        }

        progressView.progress = progress
    }
    func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        progressView.progress = 1.0   // download complete

        let data = buffer
            let json = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            if let response = task.response as? NSHTTPURLResponse where 200...299 ~= response.statusCode {
                self.handler?(success: true, object: json)
            }else {
                print("error: \(error!.localizedDescription)")
                self.handler?(success: false, object: json)

            }

        buffer = NSMutableData()

    }

    //MARK: AutoLayout

    // FIXME: Still getting some broken constraints - look into autoresizng
    func setRotatedLayout() {
        clearConstraints()


        let margins = view.layoutMarginsGuide

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
        titleLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor, constant: 50).active = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraintEqualToAnchor(titleLabel.layoutMarginsGuide.bottomAnchor, constant: 50).active = true
        progressView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20).active = true
        progressView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.topAnchor.constraintEqualToAnchor(progressView.bottomAnchor, constant: 50).active = true
        locationTextField.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20).active = true
        locationTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraintEqualToAnchor(locationTextField.layoutMarginsGuide.bottomAnchor, constant: 25).active = true
        submitButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true
         self.view.layoutIfNeeded()

    }

    func setPotraitLayout() {
        clearConstraints()

        let margins = view.layoutMarginsGuide

        view.translatesAutoresizingMaskIntoConstraints = true

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

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraintEqualToAnchor(locationTextField.layoutMarginsGuide.bottomAnchor, constant: 50).active = true
        submitButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

         self.view.layoutIfNeeded()

    }

    func clearConstraints() {
        //set constraints to inactive 

        let margins = view.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = false
        titleLabel.topAnchor.constraintEqualToAnchor(margins.topAnchor, constant: 100).active = false

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraintEqualToAnchor(titleLabel.layoutMarginsGuide.bottomAnchor, constant: 100).active = false
        progressView.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20).active = false
        progressView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = true

        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.topAnchor.constraintEqualToAnchor(progressView.bottomAnchor, constant: 100).active = false
        locationTextField.leadingAnchor.constraintEqualToAnchor(margins.leadingAnchor, constant: 20).active = false
        locationTextField.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = false

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraintEqualToAnchor(locationTextField.layoutMarginsGuide.bottomAnchor, constant: 50).active = false
        submitButton.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor).active = false
    }





}
