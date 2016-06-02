//
//  MyFollowsTableViewController.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 16/5/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import MJRefresh

class MyFollowsTableViewController: UITableViewController {

    @IBAction func segChanged(sender: AnyObject) {
        if seg.selectedSegmentIndex == 0
        {
            apiPath = domain + "api/Account/Lives"
        }
        if seg.selectedSegmentIndex == 1
        {
            apiPath = domain + "api/Account/Shops"
        }
        tableView.mj_header.beginRefreshing()
    }
    @IBOutlet var seg: UISegmentedControl!
    @IBAction func backClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var dataArray = NSMutableArray()
    var page = 0
    var pageSize = 10
    var requestPara = NSMutableDictionary();
    var apiPath = domain + "api/Account/Lives"
    func getData()
    {
        requestPara.setValue(page, forKey: "page")
        requestPara.setValue(pageSize, forKey: "pageSize")
        //requestPara.setDictionary(paras)
        let path = apiPath
        GET(path, parameters: requestPara,
            success: { (data)-> () in
                let array = data as! [AnyObject]
                self.dataArray.addObjectsFromArray(data as! [AnyObject])
                NSLog("table reload start")
                self.tableView.reloadData()
                    {
                        NSLog("table reload finish")
                        self.tableView.mj_header.endRefreshing()
                        if array.count != 0
                        {
                            self.page += 1;
                            self.tableView.mj_footer.endRefreshing()
                            NSLog("load done")
                        }
                        else
                        {
                            self.tableView.mj_footer.endRefreshingWithNoMoreData()
                            NSLog("load done")
                        }
                }
            },
            failed:
            {()->() in
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                NSLog("load failed")
                
            }
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
        NSLog("start load more")
        getData();
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: self.reloadData)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: self.loadmoreData)
        tableView.mj_header.beginRefreshing()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.items?.forEach({ (i) in
            i.enabled = true
        })
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.items?.forEach({ (i) in
            i.enabled = false
        })
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let liveCell = tableView.dequeueReusableCellWithIdentifier("LiveCell")
        let eventCell = tableView.dequeueReusableCellWithIdentifier("EventCell")
        if(seg.selectedSegmentIndex == 0)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("LiveCell", forIndexPath: indexPath) as! LiveCell
            if dataArray.count > indexPath.row
            {
                let model = (dataArray.objectAtIndex(indexPath.row) as! NSDictionary).objectForKey("cloudLive") as! NSDictionary
                cell.show(model)
            }
            return cell
        }
        if(seg.selectedSegmentIndex == 1)
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventCell
            if dataArray.count > indexPath.row
            {
                let data = dataArray.objectAtIndex(indexPath.item) as! NSDictionary
                cell.showModel(data)
            }
            
            // Configure the cell...
            
            return cell
        }
        return UITableViewCell()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if seg.selectedSegmentIndex == 0
        {
            return 131
        }
        if seg.selectedSegmentIndex == 1
        {
            return 86
        }
        return UITableViewAutomaticDimension
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(ActivityViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let model = dataArray.objectAtIndex(indexPath!.row) as! NSDictionary
            let vc = segue.destinationViewController as! ActivityViewController
            vc.model = model
        }
        if segue.destinationViewController.isKindOfClass(EventDetailViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let model = dataArray[indexPath!.item] as! NSDictionary
            
            let vc = segue.destinationViewController as! EventDetailViewController
            vc.eventModel = model
        }
    }


}
