//
//  ChatRoomViewController.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 15/5/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit
import KVNProgress
class LiveChatRoomViewController: ChatRoomViewController {

    override func viewDidLoad()
    {
        
        //AVOSCloud.setApplicationId("m7baukzusy3l5coew0b3em5uf4df5i2krky0ypbmee358yon", clientKey: "2e46velw0mqrq3hl2a047yjtpxn32frm0m253k258xo63ft9")
        openLean()
      
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openLean()
    {
        let imClient = AVIMClient.defaultClient()
        let seflClientId = (userDict.objectForKey("userName") as? String) ?? "xyxd"
        imClient.openWithClientId(seflClientId){(succeeded,error) in
            if error != nil
            {
                KVNProgress.showErrorWithStatus("连接聊天室失败")
                //let av = UIAlertView(
                //av.show()
            }
            else
            {
                super.viewDidLoad()
            }
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
