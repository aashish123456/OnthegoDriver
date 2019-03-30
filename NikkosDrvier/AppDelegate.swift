//
//  AppDelegate.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 31/08/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var loginObj: LoginModal!
    var player : AVAudioPlayer!
    var homeVC : HomeViewController!
    var isFromDidFinishLaunch : Bool = false
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? ) -> Bool {
        
        // Paypal sdk initilize
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction : payPalClientIdProduction, PayPalEnvironmentSandbox: payPalClientIdDevelopment])
        
        // Override point for customization after application launch.
        UIApplication.shared.statusBarStyle = .lightContent
        //new date
        SharedStorage.setLanguage(NikkosDriverManager.k_ENGLISH)
        //always forground appliation
        UIApplication.shared.isIdleTimerDisabled = true
        // iOS 10 support
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
        else{
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
        
       if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
            var userInfo = (launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any])!
                let aps = userInfo["aps"] as! NSDictionary
                let apsId = userInfo["PrimaryId"] as! Int
                let apsMsg = userInfo["MsgType"] as! String
                let tripID : NSNumber = Int(apsId) as NSNumber
                isFromDidFinishLaunch = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if SharedStorage.getIsRememberMe() == true
                    {
                    SharedStorage.setTripId(tripID)
                    self.handleUserInfo(aps as! Dictionary<String, AnyObject>, id: apsId , msg: apsMsg , userInfoDic : userInfo as NSDictionary)
                    }
                }
        }
        return true
    }
    
    func upadteDeviceToken(_ token:String)
    {
        self.loginObj = SharedStorage.getUser()
        let parameters: [String: AnyObject] =
            [
                "DeviceToken"      : token as AnyObject,
                "DriverId"         :     self.loginObj.driverId as AnyObject,
                ]
        NSLog("%@", parameters)
        NikkosDriverManager.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "UpdateDriverDeviceToken"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosDriverManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                }else
                {
                    // CIError("OOPs something went wrong.")
                }
            }
            else
            {
                // CIError("OOPs something went wrong.")
                
            }
            
        }
        
    }
    
    @inline(never) func showHud(){
        SVProgressHUD.show(with: .black)
    }
    
    @inline(never) func dissmissHud(){
        SVProgressHUD.dismiss()
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let deviceTokens = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        if deviceTokens != SharedStorage.getDeviceToken()
        {
            if UserDefaults.standard.object(forKey: "NC_user") != nil
            {
                upadteDeviceToken(deviceTokens)
            }
        }
        SharedStorage.setDeviceToken(deviceTokens)
        print(":Device token is :::::\(SharedStorage.getDeviceToken())")
        
    }
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("i am not available in simulator \(error)")
        SharedStorage.setDeviceToken("F6E921B2D76AA5F804FBC46B41B2B451A08E262B181DD8E2F0024DA05B9FCEA8")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //Got Notification
        
        print(":::::::::::\(userInfo)")
        let aps = userInfo["aps"] as! NSDictionary
        let apsId = userInfo["PrimaryId"] as! Int
        let apsMsg = userInfo["MsgType"] as! String
        isFromDidFinishLaunch = false
        if SharedStorage.getIsRememberMe() == true
        {
        self.handleUserInfo(aps as! Dictionary<String, AnyObject> , id: apsId , msg: apsMsg , userInfoDic : userInfo as NSDictionary)
        }
    }
    
    
    
    func handleUserInfo(_ objDictionary:Dictionary< String,AnyObject> , id: Int ,  msg : String , userInfoDic : NSDictionary)  {
        NSLog("handle")
        /*
         [aps: {
         alert = "Accept For Book Ride";
         badge = 0;
         sound = default;
         }, PrimaryId: 39, MsgType: BookingRequest]
         */
        /*
         [aps: {
         alert = "You have exceeded maximum 'Decline Ride Request' limit";
         badge = 0;
         sound = default;
         }, MsgType: GoOffLine, PrimaryId: 641]
         */
        
        // Paypal sdk initilize
        PayPalMobile.initializeWithClientIds(forEnvironments: [PayPalEnvironmentProduction : payPalClientIdProduction, PayPalEnvironmentSandbox: payPalClientIdDevelopment])
        
        if(isFromDidFinishLaunch){
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                NotificationCenter.default.post(name: Notification.Name(rawValue: "bookingRequest"), object:userInfoDic);
            }
        }else{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "bookingRequest"), object:userInfoDic);
        }
        
        
        var mp3Type : String!
        if msg == "BookingRequest"{
            mp3Type = "ForDriver_NewRequest"
                let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
                let swnav = swrevealControllerVC.frontViewController as! UINavigationController
                if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                    return
                }
                if swnav.visibleViewController!.isKind(of: HomeViewController.self){
                    
                }
                else
                {
                    let reveal = self.window?.rootViewController as! SWRevealViewController
                    let rootController:HomeViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeViewController
                   // let dict = userInfoDic
                    rootController.tripId  = String(id)
                    rootController.isAccessRequest = false
                    rootController.isFromAnotherTab = true
                    rootController.BookNowTripRequestDetailForDriver()
                    (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
                }
            
        }else if msg == "CancelRide"{
            mp3Type = "ForDriverAndRider_Trip_canceled"
        }else if msg == "GoOffLine"{
            mp3Type = "ForDriverAndRider_Trip_canceled"
        }else if msg == "AccessBookingRequest"{
            mp3Type = "For_Driver_NewRequest_ACCESS"
            
            let swrevealControllerVC =  self.window?.rootViewController as! SWRevealViewController
            let swnav = swrevealControllerVC.frontViewController as! UINavigationController
            if  ((swnav.childViewControllers.last?.presentedViewController) != nil){
                return
            }
            if swnav.visibleViewController!.isKind(of: HomeViewController.self){
                
            }else{
                let reveal = self.window?.rootViewController as! SWRevealViewController
                let rootController:HomeViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "Home") as! HomeViewController
                let dict = userInfoDic
                rootController.tripId  = String(dict["PrimaryId"] as! Int)
                rootController.isAccessRequest = true
                rootController.isFromAnotherTab = true
                rootController.BookNowTripRequestDetailForDriver()
                (reveal.frontViewController as! UINavigationController).pushViewController(rootController, animated: false)
            }
        }
        else if msg == "DeviceUpdatedOnLogin"{
            mp3Type = "ForDriverAndRider_Trip_canceled"
            SharedStorage.setIsRememberMe(false)
            SharedStorage.setDriverId(0)
            UserDefaults.standard.set("", forKey: "NC_user")
            UserDefaults.standard.synchronize()
            SharedStorage.setUnderCapaDriverId(0)
            self.loadSignInViewController()
        }
        else{
            mp3Type = "ForDriverAndRider_Trip_canceled"
        }
        let path = Bundle.main.path(forResource: mp3Type, ofType:"mp3")
        let fileURL = URL(fileURLWithPath: path!)
        player = try! AVAudioPlayer(contentsOf: fileURL, fileTypeHint: nil)
        player.prepareToPlay()
        player.play()
        
    }

    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //LoginViewController
    func loadSignInViewController() {
        let rootController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        window?.rootViewController = rootController
    }
    //HomeViewController
    func loadHomeViewController() {
        let objUIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainNavigation = objUIStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        window?.rootViewController = mainNavigation
    }

}

