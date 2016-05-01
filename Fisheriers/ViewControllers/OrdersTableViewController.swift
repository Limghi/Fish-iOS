//
//  OrdersTableViewController.swift
//  Fisheriers
//
//  Created by Lost on 04/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import DownPicker
import MJRefresh

class OrdersTableViewController: UITableViewController {
    
    @IBOutlet var filterView: UIView!
    

    var timeSelectList = ["全部时间","最近三十天","最近一周"]
    var statuSelectList = ["全部状态","未支付","已支付","已使用","已取消"]
    
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var statuTF: UITextField!
    @IBOutlet weak var statuButton: UIButton!

    var timePicker : DownPicker!
    var statuPicker : DownPicker!
    
    @IBAction func backClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    var dth : CGFloat = 200
    var dsh : CGFloat = 200
    var timePara = 0
    var statuPara = 0
    
    var filterOpen = false
    
    @IBAction func timeClicked(sender: AnyObject) {
        filterOpen = true
         tableView.reloadData()

    }
    @IBAction func statuClicked(sender: AnyObject) {
        filterOpen = true
        tableView.reloadData()

    }
    
    var array = NSMutableArray()
    var filteredArray = NSArray()
    
    
    func getData()
    {
        
        let path = "\(domain)api/Orders?time=\(timePara)&statu=\(statuPara)"
        GET(path, parameters: nil, success: { (data)-> () in
            self.array.removeAllObjects()
            self.array.addObjectsFromArray(data as! [AnyObject])
             self.filteredArray = self.array
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker = DownPicker(textField: timeTF, withData: timeSelectList)
        statuPicker = DownPicker(textField: statuTF, withData: statuSelectList)
        view.addSubview(timePicker)
        view.addSubview(statuPicker)
        
        timePicker.addTarget(self, action: #selector(OrdersTableViewController.timeChanged), forControlEvents: UIControlEvents.ValueChanged)
        statuPicker.addTarget(self, action: #selector(OrdersTableViewController.statuChanged), forControlEvents: UIControlEvents.ValueChanged)

        filterView.frame.size.width = view.frame.size.width
        
        //setUserButton()
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: self.getData)
        tableView.mj_header.beginRefreshing()
        //dropDownTime.sho
    }
    
    func timeChanged()
    {
        timePara = timePicker.selectedIndex
        timeButton.setTitle(timePicker.text, forState: UIControlState.Normal)
        tableView.mj_header.beginRefreshing()

    }
    
    func statuChanged()
    {
        statuPara = statuPicker.selectedIndex
        statuButton.setTitle(statuPicker.text, forState: UIControlState.Normal)
        tableView.mj_header.beginRefreshing()

        
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //array.removeAllObjects()
        //getData()
    }
    
 
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell", forIndexPath: indexPath) as! OrderCell
        let orderModel = filteredArray[indexPath.item] as! NSDictionary
        // Configure the cell...
        cell.show(orderModel)
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(OrderDetailViewController)
        {
            let vc = segue.destinationViewController as! OrderDetailViewController
            let orderModel = filteredArray[tableView.indexPathForSelectedRow!.item] as! NSDictionary
            vc.orderModel = orderModel
            vc.orderId = orderModel.objectForKey("id") as! Int
        }
    }

}
