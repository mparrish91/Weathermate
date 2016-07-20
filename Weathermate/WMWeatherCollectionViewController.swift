//
//  WMWeatherCollectionViewController.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit

final class WMWeatherCollectionViewController: UICollectionViewController {

    private var forecasts: [WMWeatherResponseObject]
    private var weatherCollectionView: UICollectionView


    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }

    init?(_ coder: NSCoder? = nil) {
        self.forecasts = [WMWeatherResponseObject]()
        self.weatherCollectionView = UICollectionView()

        if let coder = coder {
            super.init(coder: coder)
        }
        else {
            super.init(nibName: nil, bundle:nil)
        }
    }

    convenience init?(forecasts: [WMWeatherResponseObject]) {
        self.init()
        self.forecasts = forecasts
    }




    func retrieveWeatherNetworkingHelper() {

    }

    func handleRefresh(refreshControl: UIRefreshControl) {
    }


    // MARK: UICollectionView

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as? WMWeatherCollectionViewCell
        
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }


    // MARK: UIViewController


    override func viewDidLoad() {
        super.viewDidLoad()

        weatherCollectionView.backgroundColor = UIColor(netHex: 0xEEF4FB)

    }



    override func loadView() {

        self.view = UIView()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)

        weatherCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        weatherCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        weatherCollectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(weatherCollectionView)

    }

}
