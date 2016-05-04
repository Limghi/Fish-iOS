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
import SMSegmentView

class RefreshViewController_Table: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
   
    var dataArray = NSMutableArray()
    var page = 0
    var pageSize = 10
    var requestPara = NSMutableDictionary();
    var apiPath = domain + "api/Information"
    func getData()
    {
        requestPara.setValue(page, forKey: "page")
        requestPara.setValue(pageSize, forKey: "pageSize")
        //requestPara.setDictionary(paras)
        let path = apiPath
        GET2(path, parameters: requestPara,
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
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        NSLog("total:" + String(dataArray.count))
        NSLog("current:" + String(indexPath.item))
        let cell = UITableViewCell()
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    


    
    
}
