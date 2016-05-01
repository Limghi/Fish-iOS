//
//  HomeViewController.swift
//  Fisheriers
//
//  Created by Lost on 23/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import AFNetworking
import ImagePlayerView
import MJRefresh
import DownPicker
import SMSegmentView
import HMSegmentedControl


class HomeViewController: MainTabController{

    var articlesSelectList = NSMutableArray()
    
    @IBOutlet weak var segContainer: UIView!
    var typeSegControl: HMSegmentedControl!
        
    override func viewDidLoad() {
        requestPara.setValue(1, forKey: "typeId")
        apiPath =  domain + "api/Information"
        apiAdsPath =  domain + "api/Ads/Home"
        
        let typeApiPath = domain + "api/InformationTypes"
        GET(typeApiPath, parameters: nil, success: { (data)-> () in
            self.articlesSelectList.removeAllObjects()
            self.articlesSelectList.addObjectsFromArray(data as! [AnyObject])
            self.segmentArray.addObjectsFromArray(self.articlesSelectList.mutableArrayValueForKey("name") as [AnyObject])
            
            var segFrame = self.segContainer!.frame
            segFrame.size.width = UIScreen.mainScreen().bounds.width
           
            self.typeSegControl = HMSegmentedControl(sectionTitles: self.segmentArray as [AnyObject])
             self.typeSegControl.frame = segFrame
            self.typeSegControl.autoresizingMask = [.FlexibleWidth,.FlexibleRightMargin]
            self.typeSegControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
            self.typeSegControl.selectionIndicatorColor = ColorGreen
            self.typeSegControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : ColorGreen]
            self.typeSegControl.addTarget(self, action: #selector(HomeViewController.typeChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(self.typeSegControl)
 

            //self.segmentArray.forEach { (s) -> () in self.typeSegControl.section}
            //self.segmentArray.forEach { (s) -> () in self.segmentView.addSegmentWithTitle(s as? String, onSelectionImage: nil, offSelectionImage: nil)}
            //self.segmentView.selectSegmentAtIndex(0)
        }
        )
        
        super.viewDidLoad()
        
    }
    
    func typeChanged(seg : HMSegmentedControl)
    {
        let i = seg.selectedSegmentIndex
        let typeId = articlesSelectList[i].objectForKey("id") as! Int
        apiPath =  domain + "api/Information"
        requestPara.setValue(typeId, forKey: "typeId")
        tableView.mj_header.beginRefreshing()

    }
    
    
    func articlesChanged()
    {
        
        //let articlesTypeId = articlesSelectList.indexOf(articlesPicker.text)! as Int
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! BasicCell
        if dataArray.count > indexPath.row
        {
            let data = dataArray.objectAtIndex(indexPath.item) as! NSDictionary
            cell.showInfo(data)
        }
        
        // Configure the cell...
            
            return cell
    }

    
    override func imagePlayerView(imagePlayerView: ImagePlayerView!, loadImageForImageView imageView: UIImageView!, index: Int) {
        let eventModel = adsArray[index] as? NSDictionary
        imageView.setAdImage(eventModel?.objectForKey("avatarUrl") as? String)
        
    }
    
    
    override func segmentView(segmentView: SMBasicSegmentView, didSelectSegmentAtIndex index: Int) {
        let typeId = articlesSelectList[index].objectForKey("id") as! Int
        apiPath =  domain + "api/Information"
        requestPara.setValue(typeId, forKey: "typeId")
        tableView.mj_header.beginRefreshing()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(InfoDetailViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let info = dataArray[indexPath!.item] as! NSDictionary

            let vc = segue.destinationViewController as! InfoDetailViewController
            vc.infoModel = info
        }
    }

}
