//
//  FameHallTableViewController.swift
//  Fisheriers
//
//  Created by Lost on 05/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit


class FameHallTableViewController: MainTabController {
 
    
    override func viewDidLoad() {
        apiPath = domain + "api/Celebrities"
        apiAdsPath =  domain + "api/Ads/FameHall"
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! BasicCell
        if dataArray.count > indexPath.row
        {
            let data = dataArray.objectAtIndex(indexPath.item) as! NSDictionary
            cell.showCeleberity(data)
        }

        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(FameHallPersonalViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let model = dataArray[indexPath!.item] as! NSDictionary
            
            let vc = segue.destinationViewController as! FameHallPersonalViewController
            vc.celebrityModel = model
        }
    }
}
