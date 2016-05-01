//
//  LiveCell.swift
//  Fisheriers
//
//  Created by Lost on 12/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

/*
{

"activityId":"A2015082690001",

"activityName":"openApi-cjm测试",

"activityStatus":0,

"coverImgUrl":"xxxxxxxx",

"createTime":"20150826142156",

"description":"描述信息",

"endTime":"20150829143000",

"liveNum":1,

"needIpWhiteList":0,

"needRecord":0,

"needFullView":0,

"needTimeShift":0,

"neededPushAuth":0,

"pushIpWhiteList":"",

"pushUrlValidTime":-1,

"startTime":"20150729143000",

"userCount":0,

"playMode":0


}

*/

import UIKit

class LiveCell: UITableViewCell {

    @IBOutlet weak var liveTimeLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!
    
    var activityId = ""
    
    func show(dict:NSDictionary)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日 \nHH:mm"
        
        let date = lcDateDateFormatter.dateFromString(dict.objectForKey("startTime") as! String)
        let dateString = dateFormatter.stringFromDate(date!)
        
        liveTimeLabel.text = dateString
        activityId = dict.objectForKey("activityId") as! String
        avatarView.sd_setImageWithURL(NSURL(string: dict.objectForKey("coverImgUrl") as! String))
        titleLabel.text = "  " + (dict.objectForKey("activityName") as! String)
        //introLabel.text = dict.objectForKey("description") as? String
        let statu = dict.objectForKey("activityStatus") as! Int
        if statu == 0
        {
            statuLabel.text = "未开始"
            statuLabel.backgroundColor = ColorLightGray
        }
        if statu == 1
        {
            statuLabel.text = "直播中"
            statuLabel.backgroundColor = ColorGreen
        }
        if statu == 2
        {
            statuLabel.text = "已中断"
            statuLabel.backgroundColor = ColorLightGray
        }
        if statu == 3
        {
            statuLabel.text = "已结束"
            statuLabel.backgroundColor = ColorLightGray
        }
    }
    
}
