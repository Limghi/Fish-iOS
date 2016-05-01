//
//  VOD.swift
//  Fisheriers
//
//  Created by Lost on 22/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//



class VODViewController: UIViewController, LCPlayerControlDelegate {
    
    var vuid = ""
    var control :LCPlayerViewControl!
    var playerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayer()

    }
    
    
    
    func addPlayer()
    {
        control = LCPlayerViewControl()
        control.delegate = self
        control.hiddenBackButton = true
        control.enableDownload = false
        //guard let d = control.delegate else {return}
        playerView = control.createPlayerWithOwner(self, frame: self.view.frame)
        control.registerVodPlayerWithUU(lcUUID, vu: vuid)
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
    
    override func viewWillDisappear(animated: Bool) {
        if isMovingFromParentViewController()
        {
            NSLog("Back")
            control.destroyPlayer()
        }
        if isMovingToParentViewController()
        {
            NSLog("Forward")
        }
        super.viewWillDisappear(animated)
    }

    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        //control.delegate = nil
        
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        control.destroyPlayer()
    }
    
    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue? {
        control.destroyPlayer()
        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier:identifier)
    }
    
    
    
}
