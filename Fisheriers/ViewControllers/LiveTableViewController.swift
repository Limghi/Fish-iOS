//
//  LiveTableViewController.swift
//  Fisheriers
//
//  Created by Lost on 12/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//




import UIKit
import MJRefresh
import HMSegmentedControl


class LiveTableViewController: MainTabController {

    var date = NSDate()
    var dateVC = BasicViewController()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var segContainer: UIView!
    var typeSegControl: HMSegmentedControl!
    var typeList = NSMutableArray()
    
    @IBOutlet weak var buttonDatePicker: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    @IBAction func buttonDatePickerClicked(sender: AnyObject) {
        dateVC.masterViewController = self
       navigationController?.pushViewController(dateVC, animated: true)
    }
    @IBAction func buttonDateClicked(sender: AnyObject) {
    }


    
    func filterLive(activity : NSDictionary) -> Bool
    {
       
        if (activity.objectForKey("activityStatus") as! Int) == 3
        {
            return false
        }
         return true
        let df = NSDateFormatter()
        df.dateFormat = "yyyyMMdd"
        let selectedDateString = df.stringFromDate(self.date)
        if (activity.objectForKey("startTime") as! String).containsString(selectedDateString)               {
            return true
        }
        return false
    }
    
    
    override func viewDidLoad() {
        requestPara.setValue(1, forKey: "type")
        apiPath = domain + "api/Live/LocalLive"
        apiAdsPath = domain + "api/Ads/Live"
        
        let typeApiPath = domain + "api/LiveTypes"
        GET(typeApiPath, parameters: nil, success: { (data)-> () in
            self.typeList.removeAllObjects()
            self.typeList.addObjectsFromArray(data as! [AnyObject])
            self.segmentArray.addObjectsFromArray(self.typeList.mutableArrayValueForKey("name") as [AnyObject])
            
            var segFrame = self.segContainer!.frame
            segFrame.size.width = UIScreen.mainScreen().bounds.width
            
            self.typeSegControl = HMSegmentedControl(sectionTitles: self.segmentArray as [AnyObject])
            self.typeSegControl.frame = segFrame
            self.typeSegControl.autoresizingMask = [.FlexibleWidth,.FlexibleRightMargin]
            self.typeSegControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
            self.typeSegControl.selectionIndicatorColor = ColorGreen
            self.typeSegControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : ColorGreen]
            self.typeSegControl.addTarget(self, action: #selector(LiveTableViewController.typeChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            self.view.addSubview(self.typeSegControl)
            
            
            //self.segmentArray.forEach { (s) -> () in self.typeSegControl.section}
            //self.segmentArray.forEach { (s) -> () in self.segmentView.addSegmentWithTitle(s as? String, onSelectionImage: nil, offSelectionImage: nil)}
            //self.segmentView.selectSegmentAtIndex(0)
            }
        )
        
        super.viewDidLoad()
        
        dateVC.dateSelected = date
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let dateString = dateFormatter.stringFromDate(date)
        
        buttonDate.setTitle(dateString, forState: UIControlState.Normal)
        
    }
    
    func typeChanged(seg : HMSegmentedControl)
    {
        let i = seg.selectedSegmentIndex
        let typeId = typeList[i].objectForKey("id") as! Int
         apiPath = domain + "api/Live/LocalLive"
        requestPara.setValue(typeId, forKey: "type")
        tableView.mj_header.beginRefreshing()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
          let dateString = dateFormatter.stringFromDate(date)
        buttonDate.setTitle(dateString, forState: UIControlState.Normal)
          tableView.mj_header.beginRefreshing()
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if dataArray.count == 0
        {
            return  tableView.dequeueReusableCellWithIdentifier("NoLiveCell", forIndexPath: indexPath)

        }

        let cell = tableView.dequeueReusableCellWithIdentifier("LiveCell", forIndexPath: indexPath) as! LiveCell
        if dataArray.count > indexPath.row
        {
            let model = (dataArray.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("cloudLive") as! NSDictionary
            cell.show(model)
        }
        return cell
    }
    

   func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if dataArray.count == 0
        {
            return 44
        }
        return 130
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(ActivityViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let model = (dataArray.objectAtIndex(indexPath!.row) as! NSDictionary).objectForKey("cloudLive") as! NSDictionary
            let vc = segue.destinationViewController as! ActivityViewController
            vc.activityId = model.objectForKey("activityId") as! String
        }
    }
}
