//
//  WMUserInputViewController.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


final class WMUserInputViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate, URLSessionDataDelegate, URLSessionTaskDelegate {

    fileprivate var locationTextField: UITextField
    fileprivate var progressView: UIProgressView
    fileprivate var titleLabel: UILabel
    fileprivate var submitButton: UIButton

    fileprivate var expectedContentLength = 0
    fileprivate var buffer:NSMutableData = NSMutableData()

    fileprivate var currentDeviceOrientation: UIDeviceOrientation = .unknown


    var handler: ((_ success: Bool, _ object: AnyObject?) -> ())?

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
    titleLabel.textColor = UIColor.white

    locationTextField.font = UIFont(name: "Avenir-Book", size: 20)
    locationTextField.textColor = UIColor.white
    locationTextField.attributedPlaceholder = NSAttributedString(string:"Type here to enter your city..", attributes: [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName :UIFont(name: "Avenir-Book", size: 20)!])
    locationTextField.textAlignment = .center
    locationTextField.delegate = self

    submitButton.setTitle("Submit", for: UIControlState())
    submitButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 20)
    submitButton.layer.borderWidth = 0.0
    submitButton.titleLabel?.textColor = UIColor.white

    progressView.progressTintColor = UIColor.yellow
    progressView.trackTintColor = UIColor.white

    submitButton.isHidden = true
    submitButton.addTarget(self, action: #selector(onSubmitButtonPressed), for: .touchUpInside)

    setPotraitLayout()

    NotificationCenter.default.addObserver(self, selector: #selector(WMUserInputViewController.presentBadInputAlert), name: NSNotification.Name(rawValue: "badCity"), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(WMUserInputViewController.presentBadRequestAlert), name: NSNotification.Name(rawValue: "badRequest"), object: nil)

    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        progressView.progress = 0

        //device rotation
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(WMUserInputViewController.deviceDidRotate(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        self.currentDeviceOrientation = UIDevice.current.orientation
            }


    override func loadView() {
        self.view = UIView()
        self.view.addSubview(locationTextField)
        self.view.addSubview(progressView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(submitButton)
    }

    


    func deviceDidRotate(_ notification: Notification) {
        let currentOrientation = UIDevice.current.orientation

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

      func onSubmitButtonPressed(_ sender: UIButton) {

        if let city = locationTextField.text {
            WMNetworkingHelper.sharedInstance.retrieveWeather(city.removeWhitespace()) { (data, error) in

                if let weatherVC = WMWeatherCollectionViewController(forecasts: data) {
                    DispatchQueue.main.async(execute: {
                        self.present(weatherVC, animated: true, completion: nil)
                    })
                }


            }

        }



    }

    func presentBadInputAlert() {
        //reset the progress view
        progressView.progress = 0

        let alertController = UIAlertController(title: nil, message: "oops looks like that city is not supported", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
        }))

        present(alertController, animated: true, completion: nil)
        
    }

    func presentBadRequestAlert() {
        //reset the progress view
        progressView.progress = 0

        let alertController = UIAlertController(title: nil, message: "oops something went wrong. Please try again", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
        }))

        present(alertController, animated: true, completion: nil)
        
    }

    //MARK: UITextFieldDelegate

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.characters.count > 0 {
            submitButton.isHidden = false

        }
        return true
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


    //MARK: NSURLSession

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {

        expectedContentLength = Int(response.expectedContentLength)
        print(expectedContentLength)
        completionHandler(Foundation.URLSession.ResponseDisposition.allow)
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {

        buffer.append(data)

        //want to look into more/ hack for showing download progress. because expected length always -1 currently

//        let percentageDownloaded = Float(buffer.length) / Float(expectedContentLength)
//        progressView.progress =  percentageDownloaded


        var progress: Float!

        if expectedContentLength < 0 {
            progress = (Float(buffer.length).truncatingRemainder(dividingBy: 10_000_000.0)) / 10_000_000.0
        } else {
            progress = Float(buffer.length) / Float(expectedContentLength)
        }

        progressView.progress = progress
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        progressView.progress = 1.0   // download complete

        let data = buffer
            let json = try? JSONSerialization.jsonObject(with: data as Data, options: [])
            if let response = task.response as? HTTPURLResponse, 200...299 ~= response.statusCode {
                self.handler?(true, json as AnyObject?)
            }else {
                print("error: \(error!.localizedDescription)")
                self.handler?(false, json as AnyObject?)

            }

        buffer = NSMutableData()

    }

    //MARK: AutoLayout

    // FIXME: Still getting some broken constraints - look into autoresizng
    func setRotatedLayout() {
        clearConstraints()


        let margins = view.layoutMarginsGuide

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50).isActive = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: titleLabel.layoutMarginsGuide.bottomAnchor, constant: 50).isActive = true
        progressView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 50).isActive = true
        locationTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        locationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: locationTextField.layoutMarginsGuide.bottomAnchor, constant: 25).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
         self.view.layoutIfNeeded()

    }

    func setPotraitLayout() {
        clearConstraints()

        let margins = view.layoutMarginsGuide

        view.translatesAutoresizingMaskIntoConstraints = true

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 100).isActive = true

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: titleLabel.layoutMarginsGuide.bottomAnchor, constant: 100).isActive = true
        progressView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 100).isActive = true
        locationTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = true
        locationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: locationTextField.layoutMarginsGuide.bottomAnchor, constant: 50).isActive = true
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

         self.view.layoutIfNeeded()

    }

    func clearConstraints() {
        //set constraints to inactive 

        let margins = view.layoutMarginsGuide
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = false
        titleLabel.topAnchor.constraint(equalTo: margins.topAnchor, constant: 100).isActive = false

        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.topAnchor.constraint(equalTo: titleLabel.layoutMarginsGuide.bottomAnchor, constant: 100).isActive = false
        progressView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = false
        progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 100).isActive = false
        locationTextField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 20).isActive = false
        locationTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = false

        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.topAnchor.constraint(equalTo: locationTextField.layoutMarginsGuide.bottomAnchor, constant: 50).isActive = false
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = false
    }





}
