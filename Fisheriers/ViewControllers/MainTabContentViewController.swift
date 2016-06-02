//
//  HomeViewController.swift
//  Fisheriers
//
//  Created by Lost on 23/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import ImagePlayerView
import MJRefresh
import SMSegmentView

class MainTabController: RefreshViewController_Table, ImagePlayerViewDelegate, SMSegmentViewDelegate{
    
    @IBOutlet weak var adsPlayer: ImagePlayerView!
    @IBOutlet weak var typeSegment: UIView?
    var segmentView : SMSegmentView!
    var adsArray = NSMutableArray()
    var segmentArray = NSMutableArray()
    var apiAdsPath =  domain + "api/Ads/Events"
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        navigationController?.navigationBar.translucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        getAds()
    }
    
    func getAds()
    {
        adsArray.removeAllObjects()
        let path = apiAdsPath
        GET(path, parameters: nil, success: { (data)-> () in
            self.adsArray.addObjectsFromArray(data as! [AnyObject])
            self.adsPlayer.reloadData()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adsPlayer.imagePlayerViewDelegate  = self
        setUserButton()
        setWeatherButton()
        //setLiveButton()

        
        if typeSegment == nil
        {
            return
        }
        
        let options = [keySegmentTitleFont: UIFont.systemFontOfSize(15.0), keySegmentOnSelectionColour: ColorOrange, keySegmentOffSelectionColour: UIColor.whiteColor(), keyContentVerticalMargin: Float(10.0)]
        var segFrame = typeSegment!.frame
        segFrame.size.width = UIScreen.mainScreen().bounds.width
        
        segmentView = SMSegmentView(frame: segFrame, separatorColour: UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1), separatorWidth: 1, segmentProperties:options)
        
        segmentView.delegate = self
        view.addSubview(segmentView)
        
    }
    
    

    
    func numberOfItems() -> Int {
        return adsArray.count
    }
    
    func imagePlayerView(imagePlayerView: ImagePlayerView!, loadImageForImageView imageView: UIImageView!, index: Int) {
        let eventModel = adsArray[index] as? NSDictionary
        imageView.setAdImage(eventModel?.objectForKey("avatarUrl") as? String)
        
    }
    
    func imagePlayerView(imagePlayerView: ImagePlayerView!, didTapAtIndex index: Int) {
        let adModel = adsArray[index] as? NSDictionary
        let adType = adModel?.objectForKey("adType") as! Int
        if adType == 2
        {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("EventDetailVC") as! EventDetailViewController
            let eventModel = adModel?.objectForKey("event") as! NSDictionary
            vc.eventModel = eventModel
            navigationController?.pushViewController(vc, animated: true)
        }
        if adType == 3
        {
            let vc = storyboard?.instantiateViewControllerWithIdentifier("InfoDetailVC") as! InfoDetailViewController
            let infoModel = adModel?.objectForKey("information") as! NSDictionary
            vc.infoModel = infoModel
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func segmentView(segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        
    }
    
}
