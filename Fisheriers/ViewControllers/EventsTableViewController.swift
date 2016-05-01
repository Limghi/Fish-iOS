//
//  EventsTableViewController.swift
//  Fisheriers
//
//  Created by Lost on 23/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import MJRefresh


class EventsTableViewController: MainTabController {

    var date = NSDate()
    var dateVC = BasicViewController()
    let dateFormatter = NSDateFormatter()
    
    @IBOutlet weak var buttonDatePicker: UIButton!
    @IBOutlet weak var buttonDate: UIButton!
    @IBAction func buttonDatePickerClicked(sender: AnyObject) {
        dateVC.masterViewController = self
        navigationController?.pushViewController(dateVC, animated: true)
    }
    @IBAction func buttonDateClicked(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        
        apiAdsPath =  domain + "api/Ads/Events"
        apiPath = domain + "api/Events"
     
        date = date.dateByAddingTimeInterval(60*60*24)
        dateVC.dateSelected = date;
        
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        let dateString = dateFormatter.stringFromDate(date)
        
        buttonDate.setTitle(dateString, forState: UIControlState.Normal)
        super.viewDidLoad();

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //let dateString = dateFormatter.stringFromDate(date)
        //buttonDate.setTitle(dateString, forState: UIControlState.Normal)
        
        let df = NSDateFormatter()
        df.dateFormat = "ddMMyyyy"
        //let paraDate = df.stringFromDate(date)
        //apiPath = domain + "api/Events"
        //apiPath = domain + "api/Events?date="+paraDate
        //tableView.mj_header.beginRefreshing()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! BasicCell
        if dataArray.count > indexPath.row
        {
            let data = dataArray.objectAtIndex(indexPath.item) as! NSDictionary
            cell.showEvent(data)
        }

        // Configure the cell...
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(EventDetailViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let model = dataArray[indexPath!.item] as! NSDictionary
            
            let vc = segue.destinationViewController as! EventDetailViewController
            vc.eventModel = model
        }
    }

}
