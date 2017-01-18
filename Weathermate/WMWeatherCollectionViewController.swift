//
//  WMWeatherCollectionViewController.swift
//  Weathermate
//
//  Created by parry on 7/17/16.
//  Copyright © 2016 MCP. All rights reserved.
//

import UIKit

final class WMWeatherCollectionViewController: UICollectionViewController  {

    fileprivate var forecasts: [WMWeatherResponseObject]


    required convenience init?(coder aDecoder: NSCoder) {
        self.init(aDecoder)
    }

    init?(_ coder: NSCoder? = nil) {
        self.forecasts = [WMWeatherResponseObject]()


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
        self.collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView?.register(WMWeatherCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        loadCollectionView()

    }


    // MARK: UICollectionView

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? WMWeatherCollectionViewCell {

            let day = forecasts[indexPath.row]
        
            cell.backgroundColor = UIColor(netHex: 0xCEDEF1)
            cell.highLabel.text = "high " + day.high!
            cell.lowLabel.text = "low " + day.low!
            cell.dateLabel.text = day.newDate
            if let forecast = day.forecast {
                cell.forecastImageView.image = UIImage(named: forecast)


            }

            return cell
        }else {
            let cell = UICollectionViewCell()
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {

        let inset:CGFloat = 20

        let margins:CGFloat = 10 * 2 //spacing between the cells. There will be 2 spacings
        let width = CGFloat( (collectionView.frame.width - inset - margins)/3.0)
        return CGSize(width: width, height: 152)
    }
    



    func loadCollectionView() {


        if let weatherCollectionView = collectionView {

            collectionView?.contentInset = UIEdgeInsets(top: 15, left: 10, bottom: 0, right: 10)
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

            weatherCollectionView.frame = self.view.frame
            weatherCollectionView.backgroundColor = UIColor(netHex: 0xEEF4FB)
            weatherCollectionView.alwaysBounceVertical = true
            weatherCollectionView.bounces = true

            weatherCollectionView.isScrollEnabled = true

        }
        
    }



}

extension WMWeatherCollectionViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView && scrollView.contentOffset.y < -30{
            self.dismiss(animated: true, completion: nil)
        }
    }
}
