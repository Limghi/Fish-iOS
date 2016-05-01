//
//  ResetViewController.swift
//  Fisheriers
//
//  Created by Lost on 04/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import KVNProgress

class ResetViewController: UIViewController {
    
    @IBOutlet weak var SendCodeButton: UIButton!
    @IBAction func SendCodeClicked(sender: AnyObject) {
        sendSMS()
    }
    
    @IBAction func buttonBackClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true,completion: nil)
    }
        
    @IBOutlet weak var PhoneTF: UITextField!
    @IBOutlet weak var CodeTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
        
    @IBOutlet weak var PasswordConfirmTF: UITextField!
    
    var Verified = false
    
    func sendSMS()
    {
        //SMSSDK.get
        
        SMSSDK.getVerificationCodeByMethod(SMSGetCodeMethodSMS, phoneNumber: PhoneTF.text ?? "", zone: "86", customIdentifier: nil) { (error) -> Void in
            if (error==nil)
            {
                KVNProgress.showSuccess()
                self.SendCodeButton.setTitle("再次发送", forState: UIControlState.Normal)
            }
            else
            {
                KVNProgress.showErrorWithStatus("发送失败")
            }
        }
        
        //        let path = domain + "api/Account/SendSMS?phoneNumber=" + PhoneTF.text!
        //        POST(path, parameters: nil, success: { (dict) -> () in
        //            KVNProgress.showSuccess()
        //            self.SendCodeButton.setTitle("再次发送", forState: UIControlState.Normal)
        //        })
    }
    
    
    @IBAction func resetClicked(sender: AnyObject) {
        reset()
    }
    
    
    func reset()
    {
        let path = domain + "api/Account/ResetPassword"
        let paras = NSMutableDictionary()
        paras.setValue(PhoneTF.text , forKey: "phoneNumber")
        paras.setValue(CodeTF.text , forKey: "verifyCode")
        paras.setValue(PasswordTF.text, forKey: "password")
        paras.setValue(PasswordConfirmTF.text , forKey: "confirmPassword")
        POST2(path, parameters: paras) { (data) -> () in
            savePhoneNumberAndPassword(self.PhoneTF.text!, password: self.PasswordTF.text!)
            self.login()
        }
    }
    
    func login()
    {
        let path = domain + "token"
        let paras = NSMutableDictionary()
        paras.setValue(PhoneTF.text , forKey: "username")
        paras.setValue(PasswordTF.text, forKey: "password")
        paras.setValue("password", forKey: "grant_type")
        SignIn2(path, parameters: paras) { (dict) -> () in
            self.dismissViewControllerAnimated(true,completion: nil)
            //self.Verified = true
            //self.performSegueWithIdentifier("Register", sender: self)
        }
    }
    
    
    
 
}
