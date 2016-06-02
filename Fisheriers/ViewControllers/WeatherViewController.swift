//
//  WeatherViewController.swift
//  Fisheriers
//
//  Created by ChaonengFeng on 12/5/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController, UIWebViewDelegate   {
    
    let path = domain + "Account/Weather"
    @IBOutlet weak var webView: UIWebView!
    var parentTabBarController : UITabBarController?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: path)!))
        webView.delegate = self
        view.frame.size.height = view.frame.size.height + 50
        //view.frame.size.width = 200
        //view.frame.size.height = 300
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if request.URLString.containsString("www.thinkpage.cn/weather/city/")
        {
            return false
        }
        return true
        
    }
    @IBAction func viewTaped(sender: AnyObject) {
        //let root = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("RootTabVC") as! RootTabBarController
        //root.enable()
        parentTabBarController?.tabBar.items?.forEach({ (i) in
            i.enabled = true
        })
        dismissViewControllerAnimated(true, completion: nil)
        
//
//        if parentViewController?.popupViewController != nil{
//            parentViewController?.dismissPopupViewControllerAnimated(true, completion: nil)
//        }
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
