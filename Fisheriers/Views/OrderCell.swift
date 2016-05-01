//
//  OrderCell.swift
//  Fisheriers
//
//  Created by Lost on 05/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit
import MJRefresh

class OrderCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    func show(orderModel : NSDictionary)
    {
        let eventModel = orderModel.objectForKey("event") as? NSDictionary
        nameLabel.text = eventModel?.objectForKey("name") as? String
        priceLabel.text = String(format: "%.2f", orderModel.objectForKey("orderPrice") as! Float) + "元"
        
        if orderModel.objectForKey("orderStatuId") as! Int == 1
        {
            statuLabel.text = "未支付"
            statuLabel.textColor = ColorGreen
        }
        if orderModel.objectForKey("orderStatuId") as! Int == 2
        {
            statuLabel.text = "已支付"
            statuLabel.textColor = ColorGray
        }
        if orderModel.objectForKey("orderStatuId") as! Int == 3
        {
            statuLabel.text = "已使用"
            statuLabel.textColor = ColorGray
        }
        if orderModel.objectForKey("orderStatuId") as! Int == 4
        {
            statuLabel.text = "已取消"
            statuLabel.textColor = ColorGray
        }
        
        timeLabel.text = orderModel.objectForKey("orderTime") as? String
    }

}
