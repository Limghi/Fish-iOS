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
    @IBAction func liveButtonClicked(sender: AnyObject) {
        liveButtonClicked()
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
    
    //override func viewDidAppear(animated: Bool) {
        //super.viewDidAppear(animated)
        //setContent()
    //}
    
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
        UpdateAvatar(img) { () -> () in
            KVNProgress.show()
            //self.avatarView.image = img
            GetUserInfo({
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
        if identifier == "Live" || identifier == "Live2"
        {
            return true
            if (userDict.objectForKey("liveId") as? Int) == nil
            {
                return true
            }
            else
            {
                
                let live = userDict.objectForKey("live")
                let activityId = live?.objectForKey("cloudLiveId") as! String
                let bundle = NSBundle(URL: NSBundle.mainBundle().URLForResource("LCStreamingBundle" , withExtension: "bundle")!)
                let vc = CaptureStreamingViewController(nibName: "CaptureStreamingViewController", bundle: bundle, title: nil, activityId: activityId, userId: "823100", secretKey: "2e44b05a1d3b751efc6a3a3eb1654e79", orientation: CaptureStreamingViewControllerOrientation.Landscape)
                self.presentViewController(vc, animated: true, completion: nil)
                return false
            }
            
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
