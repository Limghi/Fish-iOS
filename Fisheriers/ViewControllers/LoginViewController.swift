//
//  LoginViewController.swift
//  Fisheriers
//
//  Created by Lost on 04/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit

func savePhoneNumberAndPassword(phoneNumber:String, password:String)
{
    let userDefaults = NSUserDefaults()
    
    userDefaults.setObject(phoneNumber, forKey: "phoneNumber")
    userDefaults.setObject(password, forKey: "password")
    userDefaults.synchronize()
}

func removePhoneNumberAndPassword()
{
    let userDefaults = NSUserDefaults()
    
    userDefaults.setObject(nil, forKey: "phoneNumber")
    userDefaults.setObject(nil, forKey: "password")
    userDefaults.synchronize()
}



class LoginViewController: UIViewController {

    @IBOutlet weak var PhoneTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func buttonBackClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true,completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        autoLogin()
    }
    
    func autoLogin()
    {
        let userDefaults = NSUserDefaults()
        if(userDefaults.valueForKey("phoneNumber") != nil && userDefaults.valueForKey("password") != nil)
        {
            PhoneTF.text = userDefaults.valueForKey("phoneNumber") as? String
            PasswordTF.text = userDefaults.valueForKey("password") as? String
            login()
        }
    }
    
    @IBAction func loginClicked(sender: AnyObject) {
        login()
    }
    
    func login()
    {
        let path = domain + "token"
        let paras = NSMutableDictionary()
        paras.setValue(PhoneTF.text , forKey: "username")
        paras.setValue(PasswordTF.text, forKey: "password")
        paras.setValue("password", forKey: "grant_type")
        SignIn(path, parameters: paras) { (dict) -> () in
            savePhoneNumberAndPassword(self.PhoneTF.text!, password: self.PasswordTF.text!)
            self.dismissViewControllerAnimated(true,completion: nil)
            //self.Verified = true
            //self.performSegueWithIdentifier("Login", sender: self)
        }
    }
    

    override func shouldAutorotate() -> Bool {
        return false
    }
    

}
