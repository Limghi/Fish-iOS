//
//  FameHallViewController.swift
//  Fisheriers
//
//  Created by Lost on 23/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import AFNetworking

class FameHallPersonalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBAction func infoClicked(sender: AnyObject) {
        
        if !infoButton.selected
        {
            infoButton.selected = true
            videoButton.selected = false
            collectionView.hidden = true
            tableView.hidden = false
            getData()
        }

    }
    @IBAction func videoClicked(sender: AnyObject) {
        if !videoButton.selected
        {
            videoButton.selected = true
            infoButton.selected = false
            collectionView.hidden = false
            tableView.hidden = true
            getData()
        }
    }
    
    var array = NSMutableArray()
    
    func showPerson()
    {
        titleLabel.text = celebrityModel?.objectForKey("name") as? String
        introLabel.text = celebrityModel?.objectForKey("intro") as? String
        avatarView.setHeaderImage(celebrityModel?.objectForKey("avatarUrl") as? String)
    }
    
    var celebrityModel : NSDictionary?
    
    func getData()
    {
        array.removeAllObjects()
        if infoButton.selected
        {
            getInfo()
        }
        if videoButton.selected
        {
            getVideo()
        }
        
    }
    
    func getInfo()
    {
        
        let path = domain + "api/Information/CeleberityInfomation?id=" + String(celebrityModel?.objectForKey("id") as! Int)
        GET(path, parameters: nil, success: { (data)-> () in
            self.array.removeAllObjects()
            self.array.addObjectsFromArray(data as! [AnyObject])
            self.tableView.reloadData()
        })
    }
    
    func getVideo()
        {

        let path = domain + "api/Celebrities/" + String(celebrityModel?.objectForKey("id") as! Int) + "/Videos"
            GET(path, parameters: nil, success: { (data)-> () in
                self.array.removeAllObjects()
                self.array.addObjectsFromArray(data as! [AnyObject])
                self.collectionView.reloadData()
            })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //collectionView.dele
        infoButton.selected = true
        videoButton.selected = false
        collectionView.hidden = true
        showPerson()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        //collectionView.
        getData()
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let w = infoButton.frame.width
        let h = w * 8 / 14
        return CGSizeMake(w,h)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("BasicCell", forIndexPath: indexPath) as! BasicCell
        
        if(array.count > indexPath.item)
        {
        let info = array[indexPath.item] as! NSDictionary
        cell.showInfo(info)
        }
        // Configure the cell...
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("VideoCell", forIndexPath: indexPath) as! VideoCell
        if(array.count > indexPath.item)
        {
            cell.showModel(array[indexPath.item] as! NSDictionary)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(InfoDetailViewController)
        {
            let indexPath = tableView.indexPathForSelectedRow
            let model = array[indexPath!.item] as! NSDictionary
            
            let vc = segue.destinationViewController as! InfoDetailViewController
            vc.infoModel = model
        }
        
        if segue.destinationViewController.isKindOfClass(VODViewController)
        {
            let indexPath = collectionView.indexPathsForSelectedItems()?.first
            let model = array[indexPath!.item] as! NSDictionary
            
            let vc = segue.destinationViewController as! VODViewController
            vc.vuid = (model.objectForKey("vu") as? String) ?? ""
        }
    }

}
