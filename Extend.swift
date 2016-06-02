//
//  Extend.swift
//  Fisheriers
//
//  Created by Lost on 23/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import CWPopup

extension UITableView{
    func reloadData(completion:()->())
    {
        UIView.animateWithDuration(0, animations: {
            self.reloadData()
        }) { (_) in
            completion()
        }    }
}

extension UIViewController
{
    func setUserButton()
    {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "button_userinfo01"), landscapeImagePhone: UIImage(named: "button_userinfo01"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.UserIconClicked))
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        //self.navigationController?.navigationBar.backItem?.rightBarButtonItem = UIBarButtonItem()
    }
    
    
    func UserIconClicked()
    {
        if token == ""
        {
            presentViewController(UIStoryboard(name:"Login",bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
        }
        else
        {
            self.sideMenuViewController?.presentLeftMenuViewController()
        }
    }
    
    func setLiveButton()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "button_live01"), landscapeImagePhone: UIImage(named: "button_live01"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.liveButtonClicked))
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        //self.navigationController?.navigationBar.backItem?.rightBarButtonItem = UIBarButtonItem()
    }
    
    func liveButtonClicked()
    {
        let bundle = NSBundle(URL: NSBundle.mainBundle().URLForResource("LCStreamingBundle" , withExtension: "bundle")!)
        let vc = CaptureStreamingViewController(nibName: "CaptureStreamingViewController", bundle: bundle, title: nil, activityId: "A20160515000002n", userId: "823100", secretKey: "2e44b05a1d3b751efc6a3a3eb1654e79", orientation: CaptureStreamingViewControllerOrientation.Landscape)
        presentViewController(vc, animated: true, completion: nil)
        //navigationController?.pushViewController(vc, animated: true)
    }
    
    func setWeatherButton()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "button_weather01"), landscapeImagePhone: UIImage(named: "button_weather01"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(UIViewController.weatherButtonClicked))
        self.navigationController?.navigationBar.tintColor = UIColor.darkGrayColor()
        //self.navigationController?.navigationBar.backItem?.rightBarButtonItem = UIBarButtonItem()
    }
    
    func weatherButtonClicked()
    {
        let root = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootTabVC") as! RootTabBarController
        //root.disable()
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("WeatherViewController") as! WeatherViewController
        tabBarController?.tabBar.items?.forEach({ (i) in
            i.enabled = false
        })
        vc.parentTabBarController = tabBarController
        presentViewController(vc, animated: true, completion: nil)
       
//        useBlurForPopup = true

//        vc.view.frame.size.width = 200
//        vc.view.frame.size.height = 300
//        presentPopupViewController(vc,animated:true,completion:nil)
        
    }
}

extension UIImageView
{
    func setBasicImage(path : String?)
    {
        if path == nil
        {
            self.image = defaultBasicImage
        }
        else
        {
            let _path = path?.stringByReplacingOccurrencesOfString("\\", withString: "/")
            let url = NSURL(string:(domain +  _path!))
            self.sd_setImageWithURL(url, placeholderImage : defaultBasicImage)
        }
    }
    
    func setHeaderImage(path : String?)
    {
        if path == nil
        {
            self.image = defaultAvatarImage
        }
        else
        {
            let _path = path?.stringByReplacingOccurrencesOfString("\\", withString: "/")
            let url = NSURL(string:(domain +  _path!))
            self.sd_setImageWithURL(url, placeholderImage : defaultAvatarImage)
        }
    }
    
    func setAdImage(path : String?)
    {
        self.contentMode = UIViewContentMode.ScaleAspectFill
        self.layer.masksToBounds = true
        if path == nil
        {
            self.image = UIImage(named:"th.jpeg")
        }
        else
        {
            let _path = path?.stringByReplacingOccurrencesOfString("\\", withString: "/")
            let url = NSURL(string:(domain +  _path!))
            self.sd_setImageWithURL(url, placeholderImage : UIImage(named:"th.jpeg"))
        }
    }
    
    func resetUserImage(path : String?, done: ()->())
    {
        self.layer.masksToBounds = true
        if path == nil
        {
            self.image = UIImage(named:"avatar01")
        }
        else
        {
            
            let _path = path?.stringByReplacingOccurrencesOfString("\\", withString: "/").stringByReplacingOccurrencesOfString("~", withString: "")
            let url = NSURL(string:(domain +  _path!))
            SDImageCache.sharedImageCache().removeImageForKey(url?.absoluteString, fromDisk:true)
            self.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Hall-of-fame-avatar01"), completed: { (_image, _error, _type, _url) in
                done()
            })
            //self.sd_setImageWithURL(url, placeholderImage : UIImage(named:"Hall-of-fame-avatar01"))
        }
    }
    
    func setUserImage(path : String?)
    {
        self.layer.masksToBounds = true
        if path == nil
        {
            self.image = UIImage(named:"avatar01")
        }
        else
        {
            
            let _path = path?.stringByReplacingOccurrencesOfString("\\", withString: "/").stringByReplacingOccurrencesOfString("~", withString: "")
            let url = NSURL(string:(domain +  _path!))
            self.sd_setImageWithURL(url, placeholderImage : UIImage(named:"Hall-of-fame-avatar01"))
        }
    }
}