//
//  ViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 31/08/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class ViewController: UIViewController {
    
    @IBOutlet weak var userNameTxt: LoginRegisterTxtField!
    @IBOutlet weak var passwordTxt: LoginRegisterTxtField!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var rememberMeBtn: UIButton!
    @IBOutlet var lblSignInWith: setTextLabel!
     var otpTxtField: UITextField!
    var loginObj:LoginModal!
    @IBOutlet var btnNewUser: UIButton!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//       self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let gradientImage = UIImage(named: "navi.png")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: .stretch)
        self.navigationController?.navigationBar.setBackgroundImage(gradientImage, for: .default)
        
        
        // manage string for multi launguage
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
//        self.title = NikkosDriverManager.GetLocalString("Login")
        
        userNameTxt.placeholder = NikkosDriverManager.GetLocalString("Enter_your_username")
        //userNameTxt.setLeftImage("login_user")
        
        passwordTxt.placeholder = NikkosDriverManager.GetLocalString("Enter_your_password")
        //passwordTxt.setLeftImage("login_password")
        
        forgotPasswordBtn.setTitle(NikkosDriverManager.GetLocalString("Forgot_Password"), for: UIControlState())
        forgotPasswordBtn.titleLabel!.numberOfLines = 1
        forgotPasswordBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        
        //loginBtn.setTitle(NikkosDriverManager.GetLocalString("Login"), for: UIControlState())
        rememberMeBtn.setTitle(NikkosDriverManager.GetLocalString("Remember_Me"), for: UIControlState())
        rememberMeBtn.titleLabel!.numberOfLines = 1
        rememberMeBtn.titleLabel!.adjustsFontSizeToFitWidth = true
        rememberMeBtn.titleLabel?.textAlignment = .center
        
        //lblSignInWith.text = NikkosDriverManager.GetLocalString("Sign_In")
        
        btnNewUser.setTitle(NikkosDriverManager.GetLocalString("New_User_signup"), for: UIControlState())
        btnNewUser.titleLabel!.numberOfLines = 1
        btnNewUser.titleLabel!.adjustsFontSizeToFitWidth = true
        btnNewUser.titleLabel?.textAlignment = .center
        
        if SharedStorage.getIsRememberMe() == true {
            userNameTxt.text = SharedStorage.getUserNameText()
            passwordTxt.text = SharedStorage.getPasswordText()
            rememberMeBtn.isSelected = true
        }else{
            userNameTxt.text = ""
            passwordTxt.text = ""
            rememberMeBtn.isSelected = false
        }
        
        if SharedStorage.getIsRememberMe() == true{
                appDelegate.loadHomeViewController()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func loginBtnPress(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        
        if ValidateEntries() == false {
            return
        }
        if  rememberMeBtn.isSelected {
            SharedStorage.setUserNameText(NikkosDriverManager.trimString(userNameTxt.text!))
            SharedStorage.setPasswordText(NikkosDriverManager.trimString(passwordTxt.text!))
        }else{
            SharedStorage.setUserNameText("")
            SharedStorage.setPasswordText("")
        }
        //Driver = 2, Client = 3
        let userRole : String = "2"
        
        
        let parameters: [String: String] = [
            "UserName"     : NikkosDriverManager.trimString(userNameTxt.text!),
            "Password"     : NikkosDriverManager.trimString(passwordTxt.text!),
            "FaceBookId"   :  "",
            "GoogleId"     :  "",
            "DeviceToken"  : SharedStorage.getDeviceToken(),
            "UserRole"     : userRole,
            "DeviceType"   : "1",
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "GetDriverLogin"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.loginObj = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    
                    if self.loginObj .isUserActive == true
                    {
                        if self.loginObj.isPhoneVerified == false
                        {
                            self.resendOtpCode()
                            self.showOtpAlert()
                        }
                        else if self.loginObj.isEmailVerified == false
                        {
                            CIError("Please verify your email address.")
                        }
                        
                        else if self.loginObj.isDriverActive == false
                        {
                            CIError("Please wait for the administrator's approval. You will receive an email after approval.")
                            //CIError("Please add your document & vehicle document then wait for admin mail for activation.")
                            //Please add your document & vehicle document then wait for admin mail for activation.
                        }
                        else
                        {
                            if self.rememberMeBtn.isSelected {
                            SharedStorage.setIsRememberMe(true)
                            }
                            SharedStorage.setDriverId(self.loginObj.driverId as! NSNumber)
                            SharedStorage.setUser(self.loginObj)
                            SharedStorage.setIsOnlineOffine(self.loginObj.isOnline)
                            self.appDelegate.loadHomeViewController()
                        }
                    }else
                    {
                        CIError("Please contact admin for activate.")
                    }
 
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
    
    @IBAction func forgotPasswordPress(_ sender: AnyObject) {
        let alertController = UIAlertController(title: "Email?", message: "Enter Email Id!", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
                let field = alertController.textFields![0]
                self.forgotPasswordService(field.text!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = UIKeyboardType.emailAddress
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    func forgotPasswordService(_ email:String)   {
        
        if NikkosDriverManager.trimString((email)).isEmpty == true
        {
            CIError("Please enter email address.")
        }else if NikkosDriverManager.isValidEmail((email)) == false
        {
            CIError("Please enter valid email address.")
        }
        else
       {
        
        let parameters: [String: String] = [
            "Email"      : email,
            "User_Role" : "2",
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "ForgetPassword"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
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
    }
    
    @IBAction func NewUserSignUpBtnPres(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "Register", sender: nil)
    }
    @IBAction func rememberMebtnPress(_ sender: AnyObject) {
        rememberMeBtn.isSelected = !rememberMeBtn.isSelected
        if rememberMeBtn.isSelected{
            SharedStorage.setIsRememberMe(true)
            
        }else{
            
            SharedStorage.setIsRememberMe(false)
        }
    }
    
    @IBAction func fbBtnPress(_ sender: AnyObject) {
    }
    
    @IBAction func googleBtnPress(_ sender: AnyObject) {
    }
    //OTP
    func wordEnteredOtp(_ alert: UIAlertAction!){
        // store the new word
        self.submitOtp()
    }
   
    func resend(_ alert: UIAlertAction!){
        self.resendOtpCode()
         self.showOtpAlert()
    }
    func addTextFieldOtp(_ textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "OTP"
        textField.keyboardType = UIKeyboardType.numberPad
        textFieldDidBeginEditing(textField)
        otpTxtField = textField
    }
    func textFieldDidBeginEditing(_ textField: UITextField) -> Bool {
        self.setToolbarOnTextfield(textField)
        return false
    }
    
    func setToolbarOnTextfield(_ textField : UITextField)  {
        
        let toolbar : UIToolbar  = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpaceLeft : UIBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton : UIBarButtonItem = UIBarButtonItem.init(title: "Cancel", style: UIBarButtonItemStyle.done,target: self,action: #selector(self.doneButtonPressed))
        
        
        var items = [UIBarButtonItem]()
        items.append(flexibleSpaceLeft)
        items.append(doneButton)
        toolbar.items = items
        textField.inputAccessoryView = toolbar
    }
    
    func doneButtonPressed() {
       // self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    

    
    func showOtpAlert()
    {
        let newWordPrompt = UIAlertController(title: "Verification?", message: "Enter OTP!", preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: self.addTextFieldOtp)
        //newWordPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: self.resend))
        newWordPrompt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: self.wordEnteredOtp))
        self.present(newWordPrompt, animated: true, completion: nil)
    }
    
    func submitOtp()
    {
        if otpTxtField.text?.characters.count == 0 {
            showOtpAlert()
            return
        }
        let parameters: [String: AnyObject] =
                [
                "OtpValue"   : self.otpTxtField.text! as AnyObject,
                "DriverId"      : self.loginObj.driverId as AnyObject,
                ]
        
        NikkosDriverManager.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "VerifyDriverLoginOTP"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosDriverManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                    self.loginBtnPress(UIButton())
                    
                    
                }else
                {
//                    CIError(data?.value(forKey: "ResponseMessage") as! String)
//                    self.showOtpAlert()
                    
                    
                    let refreshAlert = UIAlertController(title: "Onthego", message: (data?.value(forKey: "ResponseMessage") as! String), preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action: UIAlertAction!) in
                        print("Handle Ok logic here")
                        self.resendOtpCode()
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action: UIAlertAction!) in
                        print("Handle Cancel Logic here")
                        self.showOtpAlert()
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
                
                self.showOtpAlert()
            }
            
        }
        
    }
    
    func resendOtpCode()
    {
        let parameters: [String: AnyObject] =
            [
                "ID"      : self.loginObj.driverId as AnyObject,
            ]
       // NikkosDriverManager.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "ResendDriverLoginOTP"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
         //   NikkosDriverManager.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    //self.loginBtnPress(UIButton())
                    self.showOtpAlert()
                }else
                {
                    //self.showOtpAlert()
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
                //self.showOtpAlert()
            }
        }
        
    }

    func ValidateEntries() -> Bool {
        
        if NikkosDriverManager.trimString((userNameTxt?.text)!).isEmpty == true
        {
            CIError("Please enter email address.")
            return false
        }
        else if NikkosDriverManager.isValidEmail((userNameTxt?.text)!) == false
        {
            CIError("Please enter valid email address.")
            return false
        }
        else if NikkosDriverManager.trimString((passwordTxt?.text)!).isEmpty == true
        {
            CIError("Please enter password.")
            return false
        }
//        else if passwordTxt.text?.characters.count < 6{
//            CIError("Le mot de passe doit comporter au moins 6 caractères.")
//            return false
//        }
        else{
            return true
        }
        
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "Register"{
          let  registrationVC = segue.destination as! RegisterViewController
        }
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

