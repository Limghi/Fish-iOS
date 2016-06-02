//
//  LiveRequestViewController.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 17/5/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import KVNProgress


class LiveRequestViewController: UIViewController {
    @IBOutlet weak var requestView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var idTF: UITextField!
    @IBOutlet weak var liveNameTF: UITextField!
    @IBOutlet weak var subButton: UIButton!
    @IBAction func subButtonClicked(sender: AnyObject) {
        sub()
    }
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backButtonClicked(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var refreshButton: UIButton!
    @IBAction func refreshButtonClicked(sender: AnyObject) {
        checkRequest()
    }
    
    
    @IBOutlet weak var testButton: UIButton!
    @IBAction func testButtonClicked(sender: AnyObject) {
        liveButtonClicked()
    }
    @IBOutlet weak var startButton: UIButton!
    
    @IBAction func startButtonClicked(sender: AnyObject) {
        let live = userDict.objectForKey("live")
        let activityId = live?.objectForKey("cloudLiveId") as! String
        let bundle = NSBundle(URL: NSBundle.mainBundle().URLForResource("LCStreamingBundle" , withExtension: "bundle")!)
        let vc = CaptureStreamingViewController(nibName: "CaptureStreamingViewController", bundle: bundle, title: nil, activityId: activityId, userId: "823100", secretKey: "2e44b05a1d3b751efc6a3a3eb1654e79", orientation: CaptureStreamingViewControllerOrientation.Landscape)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLive()
    }
    
    func checkLive()
    {
        let live = userDict.objectForKey("live") as? NSDictionary
        let activityId = live?.objectForKey("cloudLiveId") as? String
        if activityId ?? "" != ""
        {
            requestView.hidden = true
        }
        else
        {
            checkRequest()
        }
    }
    
    func checkRequest()
    {
        let path = domain + "api/Account/LiveRequest"
        GET(path, parameters: nil, success: { o in
            let request = o as? NSDictionary
            if(request != nil)
            {
                 self.showRequest(request!)
            }
           
            }, failed: { () in })
    }
    
    func showRequest(request : NSDictionary)
    {

        if(request.objectForKey("state") == nil)
        {
            return
        }
        if(request.objectForKey("state") as! Int == 0)
        {
            titleLabel.text = "您的申请正在审核中"
            nameTF.text = request.objectForKey("fullName") as? String
            idTF.text = request.objectForKey("citizenId") as? String
            liveNameTF.text = request.objectForKey("liveName") as? String
            nameTF.enabled = false
            idTF.enabled = false
            liveNameTF.enabled = false
            subButton.hidden = true
            refreshButton.hidden = false
            subtitleLabel.hidden = true
        }
        if(request.objectForKey("state") as! Int == 2)
        {
            titleLabel.text = "您的申请被拒绝了，请重新申请"
            nameTF.text = request.objectForKey("fullName") as? String
            idTF.text = request.objectForKey("citizenId") as? String
            liveNameTF.text = request.objectForKey("liveName") as? String
            nameTF.enabled = true
            idTF.enabled = true
            liveNameTF.enabled = true
            subButton.hidden = false
            refreshButton.hidden = true
            subtitleLabel.hidden = false
        }
        if(request.objectForKey("state") as! Int == 1)
        {
            GetUserInfo()
            {
                () in
                self.checkLive()
            }
        }

    }
    
    func sub()
    {
        if nameTF.text ?? "" == "" || idTF.text ?? "" == "" || liveNameTF.text ?? "" == ""
        {
            KVNProgress.showErrorWithStatus("信息填写不完整")
            return
        }
        let path = domain + "api/UserLiveRequests"
        let para = NSMutableDictionary()
        para.setValue(nameTF.text, forKey: "fullName")
        para.setValue(idTF.text, forKey: "citizenId")
        para.setValue(liveNameTF.text, forKey: "liveName")
        POST(path, parameters: para, success: { o in
          KVNProgress.showSuccessWithStatus("提交成功")
            self.checkRequest()
        })
    }
}
