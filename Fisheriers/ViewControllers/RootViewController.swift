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
        let sb = UIStoryboard(name: "Main", bundle: nil)
        contentViewController =  sb.instantiateViewControllerWithIdentifier("RootTabVC")
        leftMenuViewController = sb.instantiateViewControllerWithIdentifier("UserVC")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
