//
//  EventDetailViewController.swift
//  Fisheriers
//
//  Created by Lost on 23/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import KVNProgress
import UIKit
import MapKit

class EventDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var originPriceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    
    @IBOutlet weak var addressButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var fishType: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var oxygenTime: UILabel!
    @IBOutlet weak var buybackPrice: UILabel!
    @IBOutlet weak var fishQuantity: UILabel!
    @IBOutlet weak var totalPosition: UILabel!
    @IBOutlet weak var discrption: UILabel!
    
    @IBOutlet weak var bookButton: UIButton!
    
    @IBAction func bookClicked(sender: AnyObject) {
        
    }
    
    @IBAction func AddClicked(sender: AnyObject) {
        openMK()
    }
    var eventModel : NSDictionary?
    var createdOrderId = 0
    
    var confirmBooking = false
    var confirmVC : UIAlertController!
    
    
    @IBOutlet weak var followButton: UIButton!
    @IBAction func followButtonClicked(sender:AnyObject)
    {
        if token == ""
        {
            presentViewController(UIStoryboard(name:"Login",bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
        }
        else
        {
            
            let shop = eventModel?.objectForKey("shop") as? NSDictionary
            let shopId = shop?.objectForKey("id") as! Int
         	
            if followButton.selected
            {
                let path = domain + "api/Shops/Unfollow/\(shopId)"
                POST(path, parameters: nil, success: { (o) in
                    KVNProgress.showWithStatus("取消关注")
                    self.followButton.selected = !self.followButton.selected
                    let _shop = getShopFromFollowed(shopId)
                    if _shop != nil
                    {
                        followShops.removeObject(_shop!)
                    }
                })
            }
            else
            {
                let path = domain + "api/Shops/Follow/\(shopId)"
                POST(path, parameters: nil, success: { (o) in
                    KVNProgress.showWithStatus("关注成功")
                    self.followButton.selected = !self.followButton.selected
                    followShops.addObject(shop!)
                })
            }
        }
    }
    

    
    func createOrder()
    {
      
        POST(domain+"api/Orders/CreateOrder/\(String(eventModel?.objectForKey("id") as! Int))", parameters: nil) { (data) -> () in
            self.createdOrderId = (data as! NSDictionary).objectForKey("id") as! Int
            self.confirmBooking = true
            self.performSegueWithIdentifier("CreateOrder", sender: self)
        }
    }
    
    func checkIsOrdered()
    {
        
        GET(domain+"api/Events/EventStatu/\(String(eventModel?.objectForKey("id") as! Int))", parameters: nil, success:  { (data) -> () in
            let dict = data as? NSDictionary
            let message = dict?.objectForKey("message") as? String
            let orderable = dict?.objectForKey("isOrderable") as? Bool
            self.bookButton.enabled = orderable ?? false
            self.bookButton.setTitle(message, forState: UIControlState.Normal)
            self.bookButton.setTitle(message, forState: UIControlState.Disabled)
            })

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if token != ""
        {
            checkIsOrdered()
            
        }
        else
        {
            self.bookButton.enabled = true
            self.bookButton.setTitle("登陆", forState: UIControlState.Normal)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel) { (UIAlertAction) -> Void in
            
        }
        let okAction = UIAlertAction(title: "确认", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.createOrder()
            
            
        }
        
        confirmVC = UIAlertController(title: "确认预定?", message: "价格：" + String(format: "%.2f", eventModel?.objectForKey("discountPrice") as! Float), preferredStyle: UIAlertControllerStyle.ActionSheet)
        confirmVC.addAction(cancelAction)
        confirmVC.addAction(okAction)

        show()
        
        
    }
    
    
    func show()
    {
        
        let shop = eventModel?.objectForKey("shop") as? NSDictionary
        fishType.text = (eventModel?.objectForKey("fishType") as? String) ?? ""
        let sts = (eventModel?.objectForKey("eventFrom") as? String ?? "").stringByReplacingOccurrencesOfString("T", withString: "  ")
        let ists = sts.startIndex.advancedBy(17)
        startTime.text = sts.substringToIndex(ists)
        let ots = (eventModel?.objectForKey("oxygenTime") as? String ?? "").stringByReplacingOccurrencesOfString("T", withString: "  ")
        if ots.characters.count > 17
        {
            let iots = ots.startIndex.advancedBy(17)
            oxygenTime.text = ots.substringToIndex(iots)
        }
        else
        {
            oxygenTime.text = ""
        }
        buybackPrice.text = "¥" + String(format: "%.2f", eventModel?.objectForKey("buyPrice") as! Float)
        fishQuantity.text = String(format: "%.2f", eventModel?.objectForKey("fishQuantity") as! Float) + "斤"
        totalPosition.text = "\(String(eventModel?.objectForKey("positions") as! Int))个"
        discrption.text = eventModel?.objectForKey("description") as? String ?? ""
        
        nameLabel.text = eventModel?.objectForKey("name") as? String
        originPriceLabel.text = "¥" + String(format: "%.2f", eventModel?.objectForKey("price") as! Float)
        discountPriceLabel.text = "¥" + String(format: "%.2f", eventModel?.objectForKey("discountPrice") as! Float)
        
        if  originPriceLabel.text == discountPriceLabel.text
        {
            discountPriceLabel.hidden = true
        }
        originPriceLabel.text = "参赛费：" +  originPriceLabel.text!
        discountPriceLabel.text = "优惠价：" + discountPriceLabel.text!
        
        
        nameLabel.text = shop?.objectForKey("name") as? String ?? ""
        introLabel.text = shop?.objectForKey("intro") as? String ?? ""
        var intro = shop?.objectForKey("name") as? String ?? ""

        introLabel.text = intro
        avatarView.setHeaderImage(eventModel?.objectForKey("avatarUrl") as? String)
        addressLabel.text = shop?.objectForKey("address") as? String
        
        let shopId = shop?.objectForKey("id") as! Int
        followButton.selected =  getShopFromFollowed(shopId) != nil

    }
    
    func openMK()
    {
        let current = MKMapItem.mapItemForCurrentLocation()
        let shop = eventModel?.objectForKey("shop") as? NSDictionary
        var latitude = shop?.objectForKey("latitude") as! Double
        var longitude = shop?.objectForKey("longitude") as! Double
        if latitude == 0
        {latitude = 39.904983}
        if longitude == 0
        {longitude = 116.427287}
        
        let destCoor = CLLocationCoordinate2DMake(latitude, longitude)
        let dest = MKMapItem(placemark: MKPlacemark(coordinate: destCoor, addressDictionary: nil))
        dest.name = shop?.objectForKey("name") as? String
        MKMapItem.openMapsWithItems([current,dest], launchOptions:
            [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                MKLaunchOptionsShowsTrafficKey:true]
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "CreateOrder" && token == ""
        {
             presentViewController(UIStoryboard(name:"Login",bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
            return false
        }
        
        if identifier == "CreateOrder" && !confirmBooking
        {
            self.presentViewController(confirmVC, animated: true, completion: { () -> Void in
                
            })
            return false
        }
        
        if identifier == "GoNavi" {
            let current = MKMapItem.mapItemForCurrentLocation()
            let shop = eventModel?.objectForKey("shop") as? NSDictionary
            var latitude = shop?.objectForKey("latitude") as! Double
            var longitude = shop?.objectForKey("longitude") as! Double
            if latitude == 0
            {latitude = 39.904983}
            if longitude == 0
            {longitude = 116.427287}

            let destCoor = CLLocationCoordinate2DMake(latitude, longitude)
            let dest = MKMapItem(placemark: MKPlacemark(coordinate: destCoor, addressDictionary: nil))
            dest.name = shop?.objectForKey("name") as? String
            MKMapItem.openMapsWithItems([current,dest], launchOptions:
                [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving,
                    MKLaunchOptionsShowsTrafficKey:true]
                )
                
            return false
        }

        
        
        
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CreateOrder"
        {
            let vc = segue.destinationViewController as! OrderDetailViewController
            vc.orderId = createdOrderId
        }
        /*
        if segue.destinationViewController.isKindOfClass(NaviViewController)
        {
            let vc = segue.destinationViewController as! NaviViewController
            let shop = eventModel?.objectForKey("shop") as? NSDictionary
            vc.title = shop?.objectForKey("name") as? String
            var latitude = shop?.objectForKey("latitude") as! Double
            var longitude = shop?.objectForKey("longitude") as! Double
            if latitude == 0
            {latitude = 39.904983}
            if longitude == 0
            {longitude = 116.427287}
            vc.endLoc = CLLocationCoordinate2DMake(latitude, longitude)
            //vc.endLoc =
            //vc.address =  shop?.objectForKey("address") as? String
            //vc.latitude = shop?.objectForKey("latitude") as! Double
            //vc.longitude = shop?.objectForKey("longitude") as! Double
            //vc.city = "北京"
            //vc.address = addressLabel.text
            //vc.title = nameLabel.text
            //vc.searchTitle = nameLabel.text

        }
 */
    }
    
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
