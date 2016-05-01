//
//  OrderDetailViewController.swift
//  Fisheriers
//
//  Created by Lost on 05/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//
import UIKit
import KVNProgress

class OrderDetailViewController: UIViewController {
    
    let kBackendChargeURL = domain + "api/Payments/Request?orderId="// 你的服务端创建并返回 charge 的 URL 地址，此地址仅供测试用。
    let kAppURLScheme = "fisher" // 这个是你定义的 URL Scheme，支付宝、微信支付和测试模式需要。
    
    
    @IBOutlet weak var goQRButton: UIButton!
    @IBOutlet weak var codeTextLabel: UILabel!
    @IBOutlet weak var statuLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    
    @IBOutlet weak var fisheriesNameLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var fishQuantityLabel: UILabel!
    @IBOutlet weak var fishBuybackLabel: UILabel!
    @IBOutlet weak var eventStartTimeLabel: UILabel!

    @IBOutlet weak var hintHeight: NSLayoutConstraint!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var goPayButton: UIButton!
    
    @IBAction func goPayClicked(sender: AnyObject) {
        createPayment()
    }
    var orderModel : NSDictionary?
    var eventModel : NSDictionary?
    var paymentModel : NSDictionary?
    var shopModel : NSDictionary?
    var orderId = 0
    var numberFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberFormatter.positiveFormat="########"
    }
    
    func getOrder()
    {
        let path = domain+"api/Orders/"+String(orderId)
        GET(path, parameters: nil, success: { (data)-> () in
            self.orderModel = data as? NSDictionary
            self.show()
        })
    }
    
    func show()
    {
        if orderModel?.objectForKey("orderStatuId") as! Int == 1
        {
            statuLabel.text = "未支付"
            hintLabel.hidden = false
            hintHeight.constant = 17
            statuLabel.textColor = ColorGreen
            goPayButton.hidden = false
            goQRButton.hidden = true
            codeTextLabel.hidden = true
        }
        if orderModel?.objectForKey("orderStatuId") as! Int == 2
        {
            hintLabel.hidden = true
            hintHeight.constant = 0
            statuLabel.text = "已支付"
            statuLabel.textColor = ColorGray
            goPayButton.hidden = true
            goQRButton.hidden = false
            codeTextLabel.hidden = false
        }
        if orderModel?.objectForKey("orderStatuId") as! Int == 3
        {
            hintLabel.hidden = true
            hintHeight.constant = 0
            statuLabel.text = "已使用"
            statuLabel.textColor = ColorGray
            goPayButton.hidden = true
            goQRButton.hidden = false
            codeTextLabel.hidden = false
        }
        if orderModel?.objectForKey("orderStatuId") as! Int == 4
        {
            hintLabel.hidden = true
            hintHeight.constant = 0
            statuLabel.text = "已取消"
            statuLabel.textColor = ColorGray
            goPayButton.hidden = true
            goQRButton.hidden = true
            codeTextLabel.hidden = true
        }
        let orderNoString = numberFormatter.stringFromNumber(orderModel?.objectForKey("id") as! Int)
        orderNumberLabel.text = "订单号：" + orderNoString!
        
        let ots = (orderModel?.objectForKey("orderTime") as? String ?? "").stringByReplacingOccurrencesOfString("T", withString: "  ")
        let iots = ots.startIndex.advancedBy(17)
        let ordertime = ots.substringToIndex(iots)
        
        orderTimeLabel.text = "下单时间：" + ordertime
        orderPriceLabel.text = "订单价：" + String(format: "%.2f", orderModel?.objectForKey("orderPrice") as! Float) + "元"
        
        eventModel = orderModel?.objectForKey("event") as? NSDictionary
        shopModel = eventModel?.objectForKey("shop") as? NSDictionary
       
        
        fisheriesNameLabel.text = "渔场名：" + (shopModel?.objectForKey("name") as? String ?? "")
        eventPriceLabel.text = "单价：" + String(format: "%.2f", eventModel?.objectForKey("price") as! Float) + "元"
        
        fishQuantityLabel.text = "放鱼量：" + String(format: "%.2f", eventModel?.objectForKey("fishQuantity") as! Float) + "斤"
        
        let buyPrice = String(format: "%.2f", eventModel?.objectForKey("buyPrice") as! Float)
        fishBuybackLabel.text = "回收价：\(buyPrice)元"
        let ets = (eventModel?.objectForKey("eventFrom") as? String ?? "").stringByReplacingOccurrencesOfString("T", withString: "  ")
        let iets =  ets.startIndex.advancedBy(17)
        let eventTime = ets.substringToIndex(iets)
        eventStartTimeLabel.text = "开始时间：" + eventTime
        codeLabel.text = (orderModel?.objectForKey("code") as? String ?? "")
        
    }
    
    func createPayment()
    {
        let path = kBackendChargeURL + String(orderId)
        let postDict : AnyObject = NSDictionary(objects: [], forKeys: [])
        var postData: NSData = NSData()
        do {
            try postData = NSJSONSerialization.dataWithJSONObject(postDict, options: NSJSONWritingOptions.PrettyPrinted)
        } catch {
            print("Serialization error")
        }
        
        let url = NSURL(string: path)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        KVNProgress.show()
        
        let sessionTask = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if data != nil {
                let charge = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(charge! as String)
                Pingpp.createPayment(charge! as String, appURLScheme: self.kAppURLScheme) { (result, error) -> Void in
                    if result == "success"
                    {
                        KVNProgress.dismiss()
                        KVNProgress.showSuccess()
                        self.getOrder()

                    }
                    if error != nil {
                        let msg = String(error.code.rawValue) + error.getMsg()
                        KVNProgress.showErrorWithStatus(msg)
                    }
                }
            } else {
                KVNProgress.show()
                print("response data is nil")
            }
        }
        sessionTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        statuLabel.text = ""
        goPayButton.hidden = true
        getOrder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "OrderDetail"
        {
            let vc = segue.destinationViewController as! EventDetailViewController
            vc.eventModel = eventModel
            
        }
        if segue.destinationViewController.isKindOfClass(PaymentViewController)
        {
            let vc = segue.destinationViewController as! PaymentViewController
            vc.orderId = orderId
        }
        if segue.destinationViewController.isKindOfClass(QRViewController)
        {
            let vc = segue.destinationViewController as! QRViewController
            vc.code = codeLabel.text ?? "1234"
        }
    }
}
