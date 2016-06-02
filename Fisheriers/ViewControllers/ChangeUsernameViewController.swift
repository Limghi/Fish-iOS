//
//  ChangeUsernameViewController.swift
//  Fisheriers
//
//  Created by Lost on 23/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//



class ChangeUsernameViewController: UIViewController {

    @IBOutlet weak var usernameTF: UITextField!
   
    var isChanged = false
    
    @IBOutlet weak var buttonConfirm: UIButton!
    @IBAction func usernameChanged(sender: AnyObject) {
        usernameTF.text = usernameTF.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if usernameTF.text == nil || usernameTF.text == ""
        {
            buttonConfirm.enabled = false
        }
        else
        {
            buttonConfirm.enabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTF.text = userDict.objectForKey("userName") as? String
        usernameTF.becomeFirstResponder()
    }
    
    func changename()
    {
        let path = domain + "api/Account/ChangeUsername?username=" + usernameTF.text!
        POST(path,parameters:nil,success: {(dict)->() in
            self.isChanged = true
            userDict.setValue(self.usernameTF.text, forKey: "userName")
            self.performSegueWithIdentifier("ChnageUsername", sender: self)
        })
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "ChnageUsername" && !isChanged
        {
            changename()
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
         if segue.identifier == "ChnageUsername"
         {
            var vc = segue.destinationViewController as! UserViewController
            
        }
    }
}
