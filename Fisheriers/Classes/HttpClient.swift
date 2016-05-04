//
//  HttpClient.swift
//  Fisheriers
//
//  Created by Lost on 05/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import Foundation
import AFNetworking
import KVNProgress
import Alamofire

var token = ""
var authorization = ["Authorization":"Bearer \(token)"]

func SignIn2(path:String,parameters:NSDictionary,success:(NSDictionary?)->())
{
    KVNProgress.show()  
    Alamofire.request(.POST, path, parameters: parameters as? [String:AnyObject] , encoding: ParameterEncoding.URL, headers: nil)
        .responseJSON { response in
            if response.response == nil
            {
                KVNProgress.showErrorWithStatus("网络无法连接")
            }
            else{
                let dict = response.result.value as! NSDictionary
                let state = response.response!.statusCode
                if state != 200
                {
                    let message = dict.objectForKey("error_description") as? String ?? ""
                    KVNProgress.showErrorWithStatus(message)
                }
                else
                {
                    token = dict.objectForKey("access_token") as! String
                    GetUserInfo2({ () -> () in
                        success(dict)
                        KVNProgress.dismiss()
                })
            }
            }
    }

}

func GET2(path:String,parameters:NSDictionary?,success:(AnyObject?)->())
{
    GET2(path,parameters: parameters,success: {(o)-> Void in success(o)},failed:{()-> Void in})
}



func GET2(path:String,parameters:NSDictionary?,success:(AnyObject?)->(),failed:()->())
{
    KVNProgress.show()
    let headers = ["Authorization":"Bearer \(token)","Content-Type":"application/json"]
    parameters as? [String:AnyObject]
    Alamofire.request(.GET, path, parameters:  parameters as? [String:AnyObject], headers: headers)
        .responseJSON {response in
            print("\(response.data)")
            if response.response == nil
            {
                 KVNProgress.dismiss()
                KVNProgress.showErrorWithStatus("网络无法连接")
                failed()

                print("\(response.request)")
            }
            else
            {
                let state = response.response!.statusCode
                if state != 200
                {
                     KVNProgress.dismiss()
                    let dict = response.result.value as! NSDictionary
                    let message = dict.objectForKey("message") as? String ?? ""
                    KVNProgress.showErrorWithStatus(message)
                    failed()
                   

                }
                else
                {
                    let dict = response.result.value
                    if let json = response.result.value{
                        print("\(json)")
                    }
                    success(dict)
                    KVNProgress.dismiss()
                }
            }
    }
}



func GET(path:String,parameters:NSDictionary?,success:(AnyObject?)->())
{
    GET2(path, parameters: parameters,success:{(object)-> Void in success(object)},failed:{()-> Void in})
}


func POST2(path:String,parameters:NSDictionary?,success:(AnyObject?)->())
{
    KVNProgress.show()
    let headers = ["Authorization":"Bearer \(token)","Content-Type":"application/json"]
    Alamofire.request(.POST, path, parameters: parameters as? [String:AnyObject] , encoding: .JSON, headers: headers)
        .responseJSON { response in
            if response.response == nil
            {
                KVNProgress.showErrorWithStatus("网络无法连接")
            }
            else
            {
                let state = response.response!.statusCode
                if state != 200
                {
                    let dict = response.result.value as! NSDictionary
                    let message = dict.objectForKey("message") as? String ?? ""
                    KVNProgress.showErrorWithStatus(message)
                }
                else
                {
                    let dict = response.result.value as? NSDictionary
                    success(dict)
                    KVNProgress.dismiss()
                }
            }
    }
}

func POST(path:String,parameters:NSDictionary?,success:(AnyObject?)->())
{
    
   POST2(path, parameters: parameters) { (o) in
    success(o)
    }
}

func updateAvatar(avatar : UIImage, success: ()->())
{
    let path = domain + "api/Account/ChangeAvatar"
    let imageData = UIImageJPEGRepresentation(avatar, 0.1)
    let paras = NSMutableDictionary()
    
    let manager = AFHTTPSessionManager()
    let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: path, parameters: nil, constructingBodyWithBlock: { (formData) -> Void in
        formData.appendPartWithFileData(imageData!, name: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")
        }, error: nil)
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("multipart/form-data", forHTTPHeaderField: "encrypt")
    manager.responseSerializer = AFJSONResponseSerializer()
    let task = manager.uploadTaskWithStreamedRequest(request, progress: nil) { (respones, object, error) -> Void in
        if error == nil
        {
            KVNProgress.showSuccess()
            success()
        }
        else
            
        {
            KVNProgress.showError()
        }
    }
    task.resume()
    
}

func GetUserInfo2(success:()->())
{
    let path = domain+"api/Account/UserDetail"
    KVNProgress.show()
    let headers = ["Authorization":"Bearer \(token)","Content-Type":"application/json"]
    Alamofire.request(.GET, path, parameters: nil , encoding: .JSON, headers: headers)
        .responseJSON { response in
            if response.response == nil
            {
                KVNProgress.showErrorWithStatus("网络无法连接")
            }
            else
            {
                let state = response.response!.statusCode
                if state != 200
                {
                    let dict = response.result.value as! NSDictionary
                    let message = dict.objectForKey("message") as? String ?? ""
                    KVNProgress.showErrorWithStatus(message)
                }
                else
                {
                    let dict = response.result.value as? NSMutableDictionary
                    userDict = dict!
                    success()
                    KVNProgress.dismiss()
                }
            }
    }}



func POST3(path:String,parameters:NSDictionary?,success:(AnyObject?)->())
{
    
    let manager = AFHTTPSessionManager()
    manager.requestSerializer = AFJSONRequestSerializer()
    manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    KVNProgress.show()
    
    //manager.requestSerializer.setValue(token, forHTTPHeaderField: "token")
    manager.POST(path, parameters: parameters, progress: nil,
                 success: { (dataTask, data) -> Void in
                    success(data)
                    KVNProgress.dismiss()
        },
                 failure:
        { (dataTask, error) -> Void in
            let r = dataTask?.response              //let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //NSLog(str as! String)
            _ = error.userInfo[2] as? NSData
            //let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //NSLog(str as! String)
            let message = error.userInfo["message"] as? String
            
            if message != nil
            {
                KVNProgress.showErrorWithStatus(message!)
            }
            else
            {
                KVNProgress.showError()
            }
            
            NSLog(error.localizedDescription)
        }
    )
}


func GET3(path:String,parameters:NSDictionary?,success:(AnyObject?)->(),failed:()->())
{
    KVNProgress.show()
    let headers = ["Authorization":"Bearer \(token)","Content-Type":"application/json"]
    Alamofire.request(.GET, path, parameters: parameters as? [String:AnyObject] , encoding: .JSON, headers: headers)
        .responseJSON { response in
            if response.response == nil
            {
                KVNProgress.showErrorWithStatus("网络无法连接")
            }
            else
            {
                let state = response.response!.statusCode
                if state != 200
                {
                    let dict = response.result.value as! NSDictionary
                    let message = dict.objectForKey("message") as? String ?? ""
                    KVNProgress.showErrorWithStatus(message)
                }
                else
                {
                    let dict = response.result.value as? NSDictionary
                    success(dict)
                    KVNProgress.dismiss()
                }
            }
    }
}

func GET4(path:String,parameters:NSDictionary?,success:(AnyObject?)->(),failed:()->())
{
    
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    KVNProgress.show()
    manager.GET(path, parameters: parameters, progress: nil,
                success: { (dataTask, data) -> Void in
                    success(data)
                    KVNProgress.dismiss()
        },
                failure:
        { (dataTask, error) -> Void in
            
            let message = error.userInfo["message"] as? String
            if message != nil
            {
                KVNProgress.showErrorWithStatus(message!)
            }
            else
            {
                KVNProgress.showError()
            }
            
            NSLog(error.localizedDescription)
            failed()
        }
    )
}

func GetUserInfo3(success:()->())
{
    let manager = AFHTTPSessionManager()
    manager.requestSerializer.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    manager.GET(domain+"api/Account/UserDetail", parameters: nil, progress: nil,
                success: { (dataTask, data) -> Void in
                    userDict = NSMutableDictionary(dictionary: data as! NSDictionary)
                    success()
    }){ (dataTask, error) -> Void in}//        { (dataTask, error) -> Void in
    //
    //            let message = error.userInfo["message"] as? String
    //            if message != nil
    //            {
    //                KVNProgress.showErrorWithStatus(message!)
    //            }
    //            else
    //            {
    //                KVNProgress.showError()
    //            }
    //
    //            NSLog(error.localizedDescription)
    //        }
    
}

func SignIn3(path:String,parameters:NSDictionary,success:(NSDictionary?)->())
{
    let manager = AFHTTPSessionManager()
    
    
    KVNProgress.show()
    manager.POST(path, parameters: parameters, progress: nil,
                 success: { (dataTask, data) -> Void in
                    let dict = data as? NSDictionary
                    token = dict?.objectForKey("access_token") as! String
                    GetUserInfo3({()->() in
                        success(dict)
                        KVNProgress.dismiss()
                    })
                    
        },
                 failure:
        { (dataTask, error) -> Void in
            
            let message = error.userInfo["message"] as? String
            if message != nil
            {
                KVNProgress.showErrorWithStatus(message!)
            }
            else
            {
                KVNProgress.showError()
            }
            
            NSLog(error.localizedDescription)
        }
    )
}