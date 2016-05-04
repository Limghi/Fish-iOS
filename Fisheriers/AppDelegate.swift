//
//  AppDelegate.swift
//  Fisheriers
//
//  Created by Lost on 19/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import KVNProgress
import RESideMenu
import SDWebImage
import ZWIntroductionViewController

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


let domain = "http://123.56.207.193/"
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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().backgroundColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = ColorGreen
        UINavigationBar.appearance().backItem?.rightBarButtonItem?.tintColor = ColorGreen
        UINavigationBar.appearance().backItem?.leftBarButtonItem?.tintColor = ColorGreen
        UINavigationBar.appearance().backItem?.backBarButtonItem?.tintColor = ColorOrange
        UINavigationBar.appearance().backItem?.backBarButtonItem?.image = UIImage(named: "button_back02")
        UINavigationBar.appearance().backItem?.backBarButtonItem?.title = "";
        UINavigationBar.appearance().backItem?.title = "";
        UINavigationBar.appearance().titleTextAttributes =
            [
                NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)!,
                NSForegroundColorAttributeName:ColorGreen
        ];
        
        UITableView.appearance().contentInset = UIEdgeInsetsZero
        UITableView.appearance().layoutMargins = UIEdgeInsetsZero
        UITableViewCell.appearance().layoutMargins = UIEdgeInsetsZero
        UITableViewCell.appearance().preservesSuperviewLayoutMargins = false
    
        LCPlayerService.sharedService().startService()
        //UITabBarItem.appearance().imageInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        //UINavigationBar.appearance().backItem?.backBarButtonItem?.
        //UINavigationBar.appearance().backItem?.leftBarButtonItem?.tintColor = ColorOrange
        IQKeyboardManager.sharedManager().enable = true
        
        serverShortDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        clientDateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        lcDateDateFormatter.dateFormat = "yyyyMMddHHmmss"
        simpleDateFormatter.dateFormat = "yyyy-MM-dd"
        
        //let ret = baiduMap.start("xqQue0oBz9HYrH6hAKOvlaFj", generalDelegate: nil)
        //if !ret
        //{
           // NSLog("baidu map start failed")
        //}
        
        
        SMSSDK.registerApp("10141f2a0a77c",withSecret:"e9d0487f02a44d28b842aaaf54bbe24f")
        //AMapNaviServices.sharedServices().apiKey = "45c53fa9745a758df0864dff33027ae3"
        //MAMapServices.sharedServices().apiKey = "45c53fa9745a758df0864dff33027ae3"
        
        Pingpp.setDebugMode(true)
        
        autoLogin()
               
        return true
    }
    
    // iOS 8 及以下请用这个
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return Pingpp.handleOpenURL(url, withCompletion: nil)
    }
    
    // iOS 9 以上请用这个
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return Pingpp.handleOpenURL(url, withCompletion: nil)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func autoLogin()
    {
        let userDefaults = NSUserDefaults()
        if(userDefaults.valueForKey("phoneNumber") != nil && userDefaults.valueForKey("password") != nil)
        {
            let phone = userDefaults.valueForKey("phoneNumber") as? String
            let password = userDefaults.valueForKey("password") as? String
            let path = domain + "token"
            let paras = NSMutableDictionary()
            paras.setValue(phone , forKey: "username")
            paras.setValue(phone, forKey: "password")
            paras.setValue("password", forKey: "grant_type")
            SignIn2(path, parameters: paras) { (dict) -> () in
                savePhoneNumberAndPassword(phone!, password: password!)
            }
        }
    }


}

