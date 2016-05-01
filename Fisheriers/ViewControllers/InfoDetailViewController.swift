//
//  InfoDetailViewController.swift
//  Fisheriers
//
//  Created by Lost on 05/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit


class InfoDetailViewController: UIViewController, UIWebViewDelegate     {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentWebView: UIWebView!
    
    @IBOutlet weak var writerLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var infoModel : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contentWebView.delegate = self
        showModel()
    }
    
    func showModel()
    {
        titleLabel.text = infoModel?.objectForKey("title") as? String
        //introLabel.text = infoModel?.objectForKey("intro") as? String
        //avatar.setHeaderImage(infoModel?.objectForKey("imageUrl") as? String)
        let url = NSURLRequest(URL:NSURL(string: (domain + "/Information/Content/" + String(infoModel?.objectForKey("id") as! Int)))!)
        contentWebView.loadRequest(url)
        //contentWebView.loadHTMLString(rewriteHtml(), baseURL: NSURL(string: domain))
        var dtString =  infoModel?.objectForKey("publishedTime") as? String
        if dtString == nil
        {
            dtString =  infoModel?.objectForKey("createdTime") as! String

        }
        let dt = serverDateFormatter.dateFromString(dtString!)
        dtString = clientDateFormatter.stringFromDate(dt!)
        dateLabel.text = dtString
        
        let celeDict = infoModel?.objectForKey("celebrity") as? NSDictionary
        if celeDict == nil
        {
            writerLabel.text = ""
        }
        else
        {
            writerLabel.text = "Written By: " + ((celeDict?.objectForKey("name") as? String) ?? "")
        }
    }
    
    func rewriteHtml() -> String
    {
        let body = infoModel?.objectForKey("content") as? String ?? ""
        let frameWidth = self.view.frame.width
        let maxWidth =  frameWidth - 20
        let final = "<body><style>img {max-width: " + String(maxWidth) + "px;}</style>" + body + "</body>"
        return final
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        let contentSize = webView.scrollView.contentSize;
        let viewSize = webView.bounds.size;
        let rw = viewSize.width / contentSize.width
        webView.scrollView.minimumZoomScale = rw
        webView.scrollView.maximumZoomScale = rw
        webView.scrollView.zoomScale = rw
    }
    
     func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType:UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.LinkClicked
        {
            UIApplication.sharedApplication().openURL(request.URL!)
            return false
        }
        return true
        
    }

}
