//
//  NikkosDriverManager.swift
//  NikkosDrvier
//
//  Created by Umang on 9/1/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class NikkosDriverManager: NSObject
{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    static var url : String = ""
    static var isOnLineOffline : Bool = true
    static var selectedIndexForActiveVehicle : NSInteger = -1
    static var carDocIndex : Int = 0
    static var k_USER_LANG : String = "USERLANGUAGE"
    static var k_FRENCH : String = "French"
    static var k_ENGLISH : String = "English"
    
    static var k_User : String = "User/"
    static var k_Driver : String = "Driver/"
    static var k_Vehicle : String = "Vehicle/"
    static var k_Common : String = "CommonDirectAuthori/"
    static var k_OnlyCommon : String = "Common/"
    static var k_Trip : String = "Trip/"
    static func UIColorFromRGB( _ r : Int, g: Int , b :Int) -> UIColor {
        return UIColor(
            red: CGFloat(r) / 255.0,
            green: CGFloat(g) / 255.0,
            blue: CGFloat(b) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func GetLocalString(_ text: String) -> String {
        var path: String
        let prefs = UserDefaults.standard
        var myString = prefs.string(forKey: k_USER_LANG)!
        myString = "en"
//        if (myString == k_FRENCH) {
//            myString = "fr"
//        }
//        else {
//            myString = "en"
//        }
        path = Bundle.main.path(forResource: myString, ofType: "lproj")!
        let languageBundle = Bundle(path: path)
        let str = languageBundle!.localizedString(forKey: text, value: "", table: nil)
        return str
    }
    
    
    static  func trimString(_ string :String) -> String{
        return string.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
    }
    
    static func isValidEmail(_ testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    static func showHud(){
        SVProgressHUD.show(with: .black)
    }
    
    static func dissmissHud(){
        SVProgressHUD.dismiss()
    }
    static  func checkNullString(_ string : AnyObject?) -> String{
        
//        if string != nil
//        {
//            return string as! String
//        } else {
//            return ""
//        }
        
        if string?.isEmpty == true
        {
            return ""
        } else {
            let str = string as? String
            if (str != nil){
                return str!
            }else{
                return ""
            }
            
        }
        
    }
    static func getToolBar(_ target: AnyObject, inputView: AnyObject , selecter: Selector)
    {
        
        let customToolBar: UIToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: 320, height: 50))
        customToolBar.barStyle = UIBarStyle.blackTranslucent
        customToolBar.barTintColor = UIColor(colorLiteralRed: 227/255.0, green: 231/255.0, blue: 235.0/255.0, alpha: 1)
        
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: target, action: selecter)
        doneButton.tintColor =  NikkosDriverManager.UIColorFromRGB(3, g: 50, b: 98)
        
        customToolBar.items = [UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil), doneButton]
        customToolBar.sizeToFit()
        
        let  txtInput : UITextField = inputView as! UITextField
        txtInput.inputAccessoryView = customToolBar
        
        
    }
    
    
    //MARK : - textFieldDone
    
    
    
    
    
}
