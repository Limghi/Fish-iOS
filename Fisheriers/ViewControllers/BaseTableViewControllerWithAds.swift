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

class BaseTableViewContollerWithAds: UIViewController, UITableViewDataSource, UITableViewDelegate, ImagePlayerViewDelegate, SMSegmentViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var adsPlayer: ImagePlayerView!
    @IBOutlet weak var typeSegment: UIView?
    
    var dataArray = NSMutableArray()
    var adsArray = NSMutableArray()
    var segmentArray = NSMutableArray()
    var page = 0
    var pageSize = 10
    var requestPara = NSMutableDictionary();
    var apiPath = domain + "api/Information"
    var apiAdsPath =  domain + "api/Ads/Events"
    
    func getData()
    {
        requestPara.setValue(page, forKey: "page")
        requestPara.setValue(pageSize, forKey: "pageSize")
        //requestPara.setDictionary(paras)
        let path = apiPath
        GET(path, parameters: requestPara, success: { (data)-> () in
            let array = data as! [AnyObject]
            if array.count != 0
            {
                self.page += 1;
            }
            self.dataArray.addObjectsFromArray(data as! [AnyObject])
            self.tableView.reloadData()
            NSLog("Load finished")
            self.tableView.mj_header.endRefreshing()
            },
            failed:{()->() in self.tableView.mj_header.endRefreshing()}
        )
    }
    
    
    func reloadData()
    {
        NSLog("start reload")
        dataArray.removeAllObjects()
        page = 0
        getData()
    }
    
    func loadmoreData()
    {
        getData();
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
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: self.reloadData)
        tableView.mj_footer = MJRefreshAutoFooter(refreshingBlock: self.loadmoreData)
        tableView.mj_header.beginRefreshing()
        
        getAds()
        
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
    
    var segmentView : SMSegmentView!
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! BasicCell
        
        let info = dataArray[indexPath.item] as! NSDictionary
        cell.showInfo(info)
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
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
