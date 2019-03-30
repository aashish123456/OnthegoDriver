//
//  WebServiceHelper.swift
//  MyHotPlaylist
//
//  Created by Anmol on 11/09/15.
//  Copyright (c) 2015 Dotsquares. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject {
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //PCServerCommunicator base url
    //static let URL : String = "http://wds2.projectstatus.co.uk/OnthegoWds/api/"
    //static let URL : String = "http://wds2.projectstatus.co.uk/OnthegoUAT/api/"
    //static let URL : String = "http://192.168.0.148/OnTheGo/api/"
    //static let URL : String = "http://192.168.0.120:8068/api/"
    static let URL : String = "https://admin.onthegocab.com/api/"
    
    static func webServiceCall(_ methodname : String, parameter : NSDictionary, httpType: String, completeBlock:@escaping (_ status : Bool, _ data : NSDictionary?, _ error : NSError?)->()){
        
        if ReachabilityForInternet.isConnectedToNetwork(){
            let baseUrl : String = self.URL + methodname
            print(baseUrl)
            let uId = SharedStorage.getDriverId()
            let url = Foundation.URL(string: baseUrl)
            let request = NSMutableURLRequest(url: url!)
            request.httpMethod = httpType
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("n1@2t3h4e5go6", forHTTPHeaderField: "AuthorizationToken")
            request.addValue("En", forHTTPHeaderField: "UserLanguage")
            if (uId != 0){
                let loginObj : LoginModal = SharedStorage.getUser()
                request.addValue(String(loginObj.countryId), forHTTPHeaderField: "CountryId")
            }else{
                request.addValue("0", forHTTPHeaderField: "CountryId")
            }
            let timezoneoffset  = NSTimeZone.system.secondsFromGMT()
            print(timezoneoffset)
            request.addValue(String(format: "%d", timezoneoffset), forHTTPHeaderField: "UtcOffsetInSecond")
            request.timeoutInterval = 120;
            /*
            let currentDate = NSDate()
            let CurrentTimeZone = NSTimeZone(forSecondsFromGMT: 0)
            let SystemTimeZone = NSTimeZone.systemTimeZone()
            let currentGMTOffset: Int = CurrentTimeZone.secondsFromGMTForDate(currentDate)
            let SystemGMTOffset: Int = SystemTimeZone.secondsFromGMTForDate(currentDate)
            let interval: NSTimeInterval = Double(SystemGMTOffset - currentGMTOffset)
            print(interval)
            */
            let err : NSError?
            err = nil
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameter, options: []);
            } catch _ {
            }
            
            do {
                if let postData : NSData = try JSONSerialization.data(withJSONObject: parameter, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData{
                    
                    let json = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
                    if (methodname != String(NikkosDriverManager.k_Driver + "GetDriverDoc")){
                      print(json)
                    }
                }
            }
            catch {
                print(error)
            }
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue(),
            completionHandler: { (responseData, response, error) -> Void in
                
                
                let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
                if response != nil{
                    var jsonResult: NSDictionary!
                    jsonResult = nil
                            do {
                                jsonResult = try JSONSerialization.jsonObject(with: response!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                            } catch _ {
                            }
                    
                    if jsonResult == nil{
                        DispatchQueue.main.async(execute: {
                            completeBlock(false, jsonResult, err)
                        })
                    }
                    else if jsonResult.value(forKey: "ResponseCode") != nil && (jsonResult.value(forKey: "ResponseCode") as! NSNumber == 201 || jsonResult.value(forKey: "ResponseCode") as! NSNumber == 204 || jsonResult.value(forKey: "ResponseCode") as! NSNumber == 403 || jsonResult.value(forKey: "ResponseCode") as! NSNumber == 49)
                    {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            if jsonResult?.value(forKey: "Data") != nil {
                                completeBlock(true, jsonResult, err)
                            }
                            appDelegate.dissmissHud()
                        }
                    }
                        
                    else if (jsonResult != nil) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(true, jsonResult, nil)
                        }
                    }
                    
                }
                    
                else if error != nil{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        completeBlock(false, nil, err)
                    }
                }
                else{
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        completeBlock(false, nil, err)
                    }
                    
                }
                
                })
        }
        else
        {
            appDelegate.dissmissHud()
            CIAlert("", "It seems that you have lost your internet access")
        }
    }
    
        static func uploadImage(_ image : UIImage, parameter : NSDictionary , completeBlock:@escaping (_ status : Bool, _ data : NSDictionary?, _ error : NSError?)->()){
            
            if ReachabilityForInternet.isConnectedToNetwork(){
                
                let boundary = generateBoundaryString()
                let data = UIImageJPEGRepresentation(image, 0.5)
                
                let dictImage = NSMutableDictionary()
                dictImage.setObject("img.png", forKey: "filename" as NSCopying)
                dictImage.setObject(data! , forKey: "fileData" as NSCopying)
                
                let arrImageData = NSArray(object: dictImage)
                
                let bodyData = createBodyWithParameters(parameter as? [String : AnyObject], filePathKey: "filename", files: arrImageData as! Array<Dictionary<String, AnyObject>>, boundary: boundary)
                
                
                let session = URLSession.shared
                let request = NSMutableURLRequest(url: Foundation.URL(string: "http://myhotplaylist.com/UploadImage.aspx")!)
                request.addValue("8bit", forHTTPHeaderField: "Content-Transfer-Encoding")
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                
                var error: NSError?
                request.httpBody = bodyData
                
                if let error = error {
                    print("\(error.localizedDescription)")
                }
                
                var err : NSError?
                //let dataTask = session.dataTask(with: request, completionHandler: { data, response, error in
                let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
                    // Handle response
                    let error: AutoreleasingUnsafeMutablePointer<NSError?>? = nil
                    if data != nil{
                        
                        var jsonResult: NSDictionary!
                        jsonResult = nil
                        
                        do {
                            jsonResult = try JSONSerialization.jsonObject(with: data!, options:JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                        } catch _ {
                        }
                        if jsonResult == nil{
//                            DispatchQueue.main.async(execute: {
//                                completeBlock(false, jsonResult, err)
//                            })
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                completeBlock(false, jsonResult, err)
                            }
                        }
                        else if jsonResult.value(forKey: "Status") != nil && (jsonResult.value(forKey: "Status") as! NSNumber == 201 || jsonResult.value(forKey: "Status") as! NSNumber == 300 || jsonResult.value(forKey: "Status") as! NSNumber == 301)
                        {
//                            DispatchQueue.main.async(execute: {
//                                completeBlock(false, jsonResult, err)
//                            })
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                completeBlock(false, jsonResult, err)
                            }
                        }
                        else if (jsonResult != nil) {
//                            DispatchQueue.main.async(execute: {
//                                completeBlock(true, jsonResult, nil)
//                            })
                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                completeBlock(true, jsonResult, nil)
                            }
                        }
                    }
                    else if error != nil{
//                        DispatchQueue.main.async(execute: {
//                            completeBlock(false, nil, err)
//                        })
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(false, nil, err)
                        }
                    }
                    else{
//                        DispatchQueue.main.async(execute: {
//                            completeBlock(false, nil, err)
//                        })
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            completeBlock(false, nil, err)
                        }
                    }
                    
                }
                
                dataTask.resume()
                
            }
            else
            {
                appDelegate.dissmissHud()
            }
            
        }
        
        
        static func createBodyWithParameters(_ parameters: [String: AnyObject]?, filePathKey: String?, files : Array<Dictionary<String, AnyObject>>, boundary: String) -> Data {
            
            let body : NSMutableData = NSMutableData();
            
            if parameters != nil {
                for (key, value) in parameters! {
                    body.append(("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                }
            }
            
            
            for file in files {
                
                let filename : String = file["filename"] as! String
                let fileData : Data = file["fileData"] as! Data
                
                
                body.append(("--\(boundary)\r\nContent-Disposition: form-data; name=\"\(filename)\"; filename=\"\(filename)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
                body.append(fileData)
                body.append(("\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            }
            body.append(("--\(boundary)--\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            return body as Data
        }
        
        
        static func generateBoundaryString() -> String {
            return "************"
        }
    }
    
    import Foundation
    import SystemConfiguration
    
    open class ReachabilityForInternet {
        class func isConnectedToNetwork() -> Bool {
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
            zeroAddress.sin_family = sa_family_t(AF_INET)
            let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
                //SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                    SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
                }
            }
            var flags = SCNetworkReachabilityFlags()
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
                return false
            }
            let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
            let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
            return (isReachable && !needsConnection)
        }
}


