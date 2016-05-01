//
//  ActivityViewController.swift
//  Fisheriers
//
//  Created by Lost on 12/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController, LCPlayerControlDelegate {
    
    var activityId = ""
    var control : LCActivityPlayerViewControl!
    var playerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addPlayer()
    }
    
    func addPlayer()
    {
        control = LCActivityPlayerViewControl()
        control.delegate = self
        control.hiddenBackButton = true
        //guard let d = control.delegate else {return}
        playerView = control.createPlayerWithOwner(self, frame: self.view.frame)
    
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
        control.destroyPlayer()
        //control.delegate = nil
    
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
    


}
