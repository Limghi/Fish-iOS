//
//  BasicCell.swift
//  Fisheriers
//
//  Created by Lost on 04/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit

class BasicCell: UITableViewCell {
    @IBOutlet var avatarView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var titleLabel: UILabel?
    
    @IBOutlet weak var timeLabel: UILabel?
    func showInfo(model:NSDictionary)
    {
        let title = model.objectForKey("title") as? String
        let intro = model.objectForKey("intro") as? String
        titleLabel?.text = title
        label.text = intro
        //label.text = (title ?? "") + "\n" + (intro ?? "")
        avatarView.setBasicImage(model.objectForKey("imageUrl") as? String)
        let date = serverDateFormatter.dateFromString(model.objectForKey("createdTime") as! String)
        let dateStr = simpleDateFormatter.stringFromDate(date!)
        timeLabel?.text = dateStr
    }
    
    func showCeleberity(model:NSDictionary)
    {
        let title = model.objectForKey("name") as? String
        let intro = model.objectForKey("intro") as? String
        label.text = (title ?? "") + "\n" + (intro ?? "")
        avatarView.setHeaderImage(model.objectForKey("avatarUrl") as? String)
    }
    
    func showEvent(model:NSDictionary)
    {
        let title = model.objectForKey("name") as? String
        let shop = model.objectForKey("shop") as? NSDictionary

        let intro = shop?.objectForKey("name") as? String
        label.text = (title ?? "") + "\n" + (intro ?? "")
        avatarView.setBasicImage(model.objectForKey("avatarUrl") as? String)
        let price =  String(format: "%.2f", model.objectForKey("discountPrice") as! Float)
        //let price = model.objectForKey("discountPrice") as? String
        priceLabel?.text = "¥" + price
        
    }

    @IBOutlet weak var priceLabel: UILabel?
}
