//
//  UserData.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 16/5/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import Foundation

let leanAppId = "F9JATEw7PKIUBQ3RObXW7n7y-gzGzoHsz"
let leanAppKey = "JMggWcALiKHQqkzj10mNuYHF"


/*
 Keys for segment properties
 */

// This is mainly for the top/bottom margin of the imageView
let keyContentVerticalMargin = "VerticalMargin"

// The colour when the segment is under selected/unselected
let keySegmentOnSelectionColour = "OnSelectionBackgroundColour"
let keySegmentOffSelectionColour = "OffSelectionBackgroundColour"

// The colour of the text in the segment for the segment is under selected/unselected
let keySegmentOnSelectionTextColour = "OnSelectionTextColour"
let keySegmentOffSelectionTextColour = "OffSelectionTextColour"

// The font of the text in the segment
let keySegmentTitleFont = "TitleFont"


let domain = "http://console.xiyuanxiongdi.com/"
let ColorBG = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
let ColorGreen = UIColor(red: 54/255, green: 207/255, blue: 160/255, alpha: 1)
let ColorOrange = UIColor(red: 255/255, green: 150/255, blue: 0/255, alpha: 1)
let ColorGray = UIColor(red: 92/255, green: 92/255, blue: 92/255, alpha: 1)
let ColorLightGray = UIColor(red: 181/255, green: 181/255, blue: 181/255, alpha: 1)
let defaultBasicImage = UIImage(named: "news-picture")
let defaultAvatarImage = UIImage(named: "Hall-of-fame-avatar01")

//let baiduMap = BMKMapManager()

let serverDateFormatter = NSDateFormatter()
let clientDateFormatter = NSDateFormatter()
let lcDateDateFormatter = NSDateFormatter()
let simpleDateFormatter = NSDateFormatter()
let serverShortDateFormatter = NSDateFormatter()

let lcUUID = "nal4hqaahb"
var userDict = NSMutableDictionary()
var followLives = NSMutableArray()
var followShops = NSMutableArray()


var token = ""
var authorization = ["Authorization":"Bearer \(token)"]



func getLiveFromFollowed(liveId : Int) -> AnyObject?
{
    for live in followLives
    {
        if (live.objectForKey("id") as! Int) == liveId
        {
            return live
        }
    }
    return nil
}

func getShopFromFollowed(shopId : Int) -> AnyObject?
{
    for shop in followShops
    {
        if (shop.objectForKey("id") as! Int) == shopId
        {
            return shop
        }
    }
    return nil
}

