//
//  ActivityViewController.swift
//  Fisheriers
//
//  Created by Lost on 12/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit
import KVNProgress
//, LCPlayerControlDelegate
class ActivityViewController: UIViewController{
    
    var liveId = 0
    var activityId = ""
    var chatId = ""
    //var control : LCActivityPlayerViewControl!
    //var control = LCPlayerViewControl()
    var playerView : UIView!
    var model = NSDictionary()
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var followButton: UIButton!
    @IBAction func followButtonClicked(sender:AnyObject)
    {
        if token == ""
        {
             presentViewController(UIStoryboard(name:"Login",bundle: nil).instantiateInitialViewController()!, animated: true, completion: nil)
        }
        else
        {
            if followButton.selected
            {
                let path = domain + "api/Live/Unfollow/\(liveId)"
                POST(path, parameters: nil, success: { (o) in
                    KVNProgress.showWithStatus("取消关注")
                    self.followButton.selected = !self.followButton.selected
                    let _live = getLiveFromFollowed(self.liveId)
                    if _live != nil
                    {
                        followLives.removeObject(_live!)
                    }

                })
            }
            else
            {
                let path = domain + "api/Live/Follow/\(liveId)"
                POST(path, parameters: nil, success: { (o) in
                    KVNProgress.showWithStatus("关注成功")
                    self.followButton.selected = !self.followButton.selected
                    followLives.addObject(self.model)
                })
            }
        }
    }
    
    var webUrl = "http://live.lecloud.com/live/playerPage/getView?activityId="
    var htmldata = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityId = model.objectForKey("cloudLiveId") as! String
        liveId = model.objectForKey("id") as! Int
        chatId = model.objectForKey("chatId") as? String ?? ""
        
        if token != ""
        {
            let _live = getLiveFromFollowed(self.liveId)
            followButton.selected = _live != nil
        }

        //activityId="A201604250000120"
        addWebPlayer()
        //addPlayer()
    }
    
    func addWebPlayer()
    {
        webView.hidden = false
        webView.allowsInlineMediaPlayback = true
        webView.mediaPlaybackRequiresUserAction = false
        webView.scrollView.scrollEnabled = false
        webUrl = webUrl + activityId
        createHtml()
        webView.loadHTMLString(htmldata, baseURL: nil)
        //webView.loadRequest(NSURLRequest(URL: NSURL(string: webUrl)!))
        
    }
    
    
    
    
    
    func createHtml()
    {
        
        htmldata = "<html><head><title>直播</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/><meta content=\"width=device-width,initial-scale=1,user-scalable=no\" name=\"viewport\"><style type=\"text/css\">body {padding: 0;margin: 0;}</style></head><body><div id=\"player\" style=\"width:100%;height:100%;\"><script type=\"text/javascript\" charset=\"utf-8\" src=\"http://yuntv.letv.com/player/live/blive.js\"></script><script>var player = new CloudLivePlayer();player.init({activityId:\"\(activityId)\"});</script></div></body></html>"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(LiveChatRoomViewController)
        {
            let vc = segue.destinationViewController as! LiveChatRoomViewController
            chatId = model.objectForKey("chatId") as? String ?? ""

            vc.chatId = chatId
        }
    }
    
    /*
    func addPlayer()
    {
        control = LCActivityPlayerViewControl()
        control.delegate = self
        control.hiddenBackButton = true
        //guard let d = control.delegate else {return}
        playerView = control.createPlayerWithOwner(self, frame: self.view.frame)
        //control.registerLivePlayerWithId(activityId, mediaType: LCPlayerMediaType.HLS)
        control.registerActivityLivePlayerWithId(activityId)
        
        view.addSubview(playerView)
        
    }
    func lcPlayerControl(playerControl: LCPlayerControl!, didChangePlayerFullScreenState fullScreen: Bool) {
        
    }
    
    func lcPlayerControl(playerControl: LCPlayerControl!, mediaTitle: String!, currentPlayTime currentPlayTimestamp: NSTimeInterval, totalTime: NSTimeInterval) {
    
    }
    
    func lcPlayerControl(playerControl: LCPlayerControl!, playerEvent event: LCPlayerControlEvent, error: NSError!) {
    
    }
    
    
    func lcPlayerControlDidClickBackBtn(playerControl: LCPlayerControl!) {
        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
  
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    
        //control.destroyPlayer()
        //control.delegate = nil
    
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    */


}
