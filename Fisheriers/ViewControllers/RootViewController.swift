//
//  RootViewController.swift
//  Fisheriers
//
//  Created by Lost on 03/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import RESideMenu

class RootViewController: RESideMenu,RESideMenuDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib();
        delegate = self
        let mainsb = UIStoryboard(name: "Main", bundle: nil)
        contentViewController =  mainsb.instantiateViewControllerWithIdentifier("RootTabVC")
        let usersb = UIStoryboard(name: "User", bundle: nil)
        leftMenuViewController = usersb.instantiateViewControllerWithIdentifier("UserVC")
        scaleMenuView = false
        scaleContentView = false
        scaleBackgroundImageView = false
        contentViewInPortraitOffsetCenterX = (view.frame.width / 2 ) - 50
        //contentViewShadowColor = UIColor.grayColor()
        contentViewShadowEnabled = true
        contentViewShadowRadius = 10
        //menuViewControllerTransformation = CGAffineTransformMakeScale(0.5,1)
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        (leftMenuViewController as! UserViewController).setContent()
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
