//
//  CustomNavigationController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 26/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
     let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isOnLineOffline : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        self.interactivePopGestureRecognizer!.isEnabled = false
    }
    func StatusButton(_ sender : UIBarButtonItem){
        
        
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "HasOnline"     : !SharedStorage.getIsOnlineOffine() as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GoOfflineOnline"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    if SharedStorage.getIsOnlineOffine() == true{
                        sender.image = UIImage(named: "off")
                        SharedStorage.setIsOnlineOffine(false)
                    }
                    else if SharedStorage.getIsOnlineOffine() == false{
                        sender.image = UIImage(named: "on")
                        SharedStorage.setIsOnlineOffine(true)
                    }
                    //CIError(data?.valueForKey("ResponseMessage") as! String)
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
        
        
    }
    
    
    func StatusButtonMethod(_ sender : UIBarButtonItem?){
        
        
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "HasOnline"     : SharedStorage.getIsOnlineOffine() as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GoOfflineOnline"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    if SharedStorage.getIsOnlineOffine() == true{
                        if sender != nil {
                        sender!.image = UIImage(named: "on")
                        }
                        //SharedStorage.setIsOnlineOffine(false)
                    }
                    else if SharedStorage.getIsOnlineOffine() == false{
                        if sender != nil {
                        sender!.image = UIImage(named: "off")
                        }
                        //SharedStorage.setIsOnlineOffine(true)
                    }
                    //CIError(data?.valueForKey("ResponseMessage") as! String)
                    
                }else
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
        
        
    }

   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
