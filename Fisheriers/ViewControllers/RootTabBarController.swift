//
//  RootViewController.swift
//  Fisheriers
//
//  Created by Lost on 21/02/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = ColorGreen
                
        //tabBar.frame.size.height = 0
        //tabBar.layer.masksToBounds = true
        //tabBar.barStyle = .Black
        //tabBar.translucent = false
        //tabBar.tintColor = UIColor.whiteColor()
        //tabBar.backgroundColor = ColorOrange
        //tabBar.backgroundImage = UIImage()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //setUserButton()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    func disable()
    {
        tabBar.hidden = true
        tabBar.items?.forEach({ (i) in
            i.enabled = false
        })
    }
    
    func enable()
    {
        tabBar.hidden = false
        tabBar.items?.forEach({ (i) in
            i.enabled = true
        })
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
