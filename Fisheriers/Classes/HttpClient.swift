//
//  HttpClient.swift
//  Fisheriers
//
//  Created by Lost on 05/03/2016.
//  Copyright © 2016 Feng. All rights reserved.
//

import Foundation
import KVNProgress
import Alamofire




func SignIn(path:String,parameters:NSDictionary,success:(NSDictionary?)->())
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
                    GetUserInfo({ () -> () in
                        success(dict)
                        KVNProgress.dismiss()
                    })
                }
            }
    }
    
}



func GET(path:String,parameters:NSDictionary?,success:(AnyObject?)->(),failed:()->())
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
                if state<200 && state>299
                {
                    KVNProgress.dismiss()
                    let dict = response.result.value as? NSDictionary
                    let message = dict?.objectForKey("message") as? String ?? ""
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
    GET(path, parameters: parameters,success:{(object)-> Void in success(object)},failed:{()-> Void in})
}


func POST(path:String,parameters:NSDictionary?,success:(AnyObject?)->(),failed:()->())
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
                let state = response.response?.statusCode
                if state != 200
                {
                    let dict = response.result.value as? NSDictionary
                    let message = dict?.objectForKey("message") as? String ?? ""
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
    
    POST(path, parameters: parameters, success: {(o) in
        success(o)}, failed:{() in })
}


func GetUserInfo(success:()->())
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
                    let dict = response.result.value as? NSDictionary
                    let message = dict?.objectForKey("message") as? String ?? ""
                    KVNProgress.showErrorWithStatus(message)
                }
                else
                {
                    let dict = response.result.value as? NSDictionary
                    if(dict != nil)
                    {
                        userDict = NSMutableDictionary(dictionary: dict!)
                    }
                    followLives.removeAllObjects()
                    followLives.addObjectsFromArray(userDict.objectForKey("followedLives") as! [AnyObject])
                    
                    followShops.removeAllObjects()
                    followShops.addObjectsFromArray(userDict.objectForKey("followedShops") as! [AnyObject])
                    //followShops = userDict.objectForKey("followedShops") as! NSMutableArray
                    success()
                    KVNProgress.dismiss()
                }
            }
    }
}

/*
func Upload()
{
    Alamofire.upload(
        .POST,
        "https://httpbin.org/post",
        multipartFormData: { multipartFormData in
            multipartFormData.appendBodyPart(fileURL: unicornImageURL, name: "unicorn")
            multipartFormData.appendBodyPart(fileURL: rainbowImageURL, name: "rainbow")
        },
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
                    debugPrint(response)
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
        }
    )
}
 */

func UpdateAvatar(avatar : UIImage, success: ()->())
{
    let headers = ["Authorization":"Bearer \(token)","encrypt":"multipart/form-data"]
    let path = domain + "api/Account/ChangeAvatar"
    let imageData = UIImageJPEGRepresentation(avatar, 0.1)
    KVNProgress.show()
    Alamofire.upload(
        .POST,
        path,
        headers: headers,
        multipartFormData: { (multipartFormData) in
            multipartFormData.appendBodyPart(data: imageData!, name: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")},
        encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseJSON { response in
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
                            success()
                            KVNProgress.dismiss()
                        }
                    }
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
        }
    )
    
    
}

/*
 Alamofire.upload(
 .POST,
 path,
 multipartFormData: { multipartFormData in
 multipartFormData.appendBodyPart(data: imageData!, name: "file", fileName: "avatar.jpg", mimeType: "image/jpeg")
 },
 encodingCompletion: { encodingResult in
 switch encodingResult {
 case .Success(let upload, _, _):
 upload.responseJSON { response in
 debugPrint(response)
 }
 case .Failure(let encodingError):
 print(encodingError)
 }
 }
 )
 */

/*
func updateAvatar2(avatar : UIImage, success: ()->())
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
 */