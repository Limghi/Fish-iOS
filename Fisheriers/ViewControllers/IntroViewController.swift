//
//  IntroViewController.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 2/4/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import ZWIntroductionViewController

import UIKit

class IntroViewController: ZWIntroductionViewController {

    var userDefaults = NSUserDefaults()
    var curVer = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
    override func viewDidLoad() {
        autoLogin()
        NSThread.sleepForTimeInterval(2)
        loadIntroOrNot()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func loadIntroOrNot()
    {
        userDefaults = NSUserDefaults()
        curVer = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
        userDefaults = NSUserDefaults()
        let lastVer = userDefaults.valueForKey("version") as? String
        if lastVer != curVer{
            enterButton = UIButton()
            enterButton.setTitle("", forState: UIControlState.Normal)
            coverImageNames = ["01","02","03","04"]
            didSelectedEnter = {self.performSegueWithIdentifier("Enter", sender: self)}
        }
    }
    
    
    func showIntroOrNot()
    {
        userDefaults = NSUserDefaults()
        curVer = NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as! String
        userDefaults = NSUserDefaults()
        let lastVer = userDefaults.valueForKey("version") as? String
        if lastVer == curVer{
            self.performSegueWithIdentifier("Enter", sender: self)
        }

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
            paras.setValue(phone, forKey: "username")
            paras.setValue(password, forKey: "password")
            paras.setValue("password", forKey: "grant_type")
            SignIn(path, parameters: paras) { (dict) -> () in
            }

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        showIntroOrNot()
    }
    
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Enter"
        {
            userDefaults.setValue(curVer, forKey: "version")
            userDefaults.synchronize()
        }
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
