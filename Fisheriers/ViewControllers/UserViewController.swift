//
//  UserViewController.swift
//  Fisheriers
//
//  Created by Lost on 03/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import KVNProgress
import UIKit
import FSMediaPicker
import AFNetworking
import SDWebImage
class UserViewController: UITableViewController, FSMediaPickerDelegate {

    @IBOutlet weak var trailingHeader: NSLayoutConstraint!
    @IBOutlet weak var trailingPhone: NSLayoutConstraint!
    @IBOutlet weak var trailingCity: NSLayoutConstraint!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBAction func avatarClicked(sender: AnyObject) {
        showPicker()
    }
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setContent()
    {
         self.title = "个人资料"
        avatarView.layer.cornerRadius = 50
        avatarView.layer.masksToBounds = true
        let userDefaults = NSUserDefaults()
        phoneLabel.text = userDefaults.valueForKey("phoneNumber") as? String
        let avatarPath = (userDict.objectForKey("avatar") as? String) ?? ""
        //let avatarUrl = NSURL(string:avatarPath)
        let username = (userDict.objectForKey("userName") as? String) ?? ""
        usernameLabel.text = username
        avatarView.setUserImage(avatarPath)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setContent()

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setContent()
    }
    
    func showPicker()
    {
        let picker = FSMediaPicker()
        picker.mediaType = FSMediaTypePhoto
        picker.editMode = FSEditModeCircular
        picker.delegate = self
        picker.showFromView(self.view)
    }
    
    func mediaPicker(mediaPicker: FSMediaPicker!, didFinishWithMediaInfo mediaInfo: [NSObject : AnyObject]!) {
        let img = mediaInfo[UIImagePickerControllerCircularEditedImage] as! UIImage
        updateAvatar(img) { () -> () in
            KVNProgress.show()
            //self.avatarView.image = img
            GetUserInfo2({
                let avatarPath = (userDict.objectForKey("avatar") as? String) ?? ""
                self.avatarView.resetUserImage(avatarPath){ _ in  KVNProgress.dismiss()}
            })
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Logout"
        {
                        return false
            
        }
        return true	
    }
    
    @IBAction func logout(sender: AnyObject) {
        removePhoneNumberAndPassword()
        token = ""
        self.sideMenuViewController?.hideMenuViewController()

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Logout"
        {
            removePhoneNumberAndPassword()
        }
        if segue.destinationViewController.isKindOfClass(ChangeUsernameViewController)
        {
            let vc = segue.destinationViewController as! ChangeUsernameViewController
        }
    }
    
        

}
