//
//  videoCell.swift
//  Fisheriers
//
//  Created by Lost on 20/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//


class VideoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var vid = ""
    
    func showModel(model: NSDictionary)
    {
        let path =  (model.objectForKey("imageUrl") as? String) ?? ""
        let url = NSURL(string: path)
        if url != nil
        {
            imageView.sd_setImageWithURL(url)
        }
        label.text = (model.objectForKey("name") as? String) ?? ""
        vid = (model.objectForKey("lcId") as? String) ?? ""
       
        //imageView.sd_setImageWithURL(NSURL(string: model.))
    }

}
