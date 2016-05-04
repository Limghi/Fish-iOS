//
//  EventCell.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 3/5/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet weak var contractView: UIImageView!
    @IBOutlet weak var liveView: UIImageView!
    @IBOutlet weak var discountView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var avatarView: UIImageView!
    
    let df = NSDateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showModel(model : NSDictionary?)
    {
        df.dateFormat="MM月dd日"
        let event = model
        let shop = model?.objectForKey("shop") as? NSDictionary
        if (event?.objectForKey("liveId") as? Int) == nil
        {
            liveView.image = UIImage(named: "icon_livenow02")
        }
        if !(shop?.objectForKey("verified") as! Bool)
        {
            contractView.image = UIImage(named: "icon_rss02")
        }
        if (event?.objectForKey("price") as! Int) == (event?.objectForKey("discountPrice") as! Int)
        {
            discountView.image = UIImage(named: "icon_Discounts02")
        }
        titleLabel.text = shop?.objectForKey("name") as? String
        introLabel.text = event?.objectForKey("intro") as? String
        avatarView.setBasicImage(event?.objectForKey("avatarUrl") as? String)
        priceLabel.text = "¥" + String(format: "%.2f", event?.objectForKey("discountPrice") as! Float)
        let date = serverShortDateFormatter.dateFromString(event?.objectForKey("eventFrom") as! String)
        dataLabel.text = df.stringFromDate(date!)
    }

}
