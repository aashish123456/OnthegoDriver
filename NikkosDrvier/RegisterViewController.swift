//
//  RegisterViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 19/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
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

class RegisterViewController: UIViewController ,TextFieldPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    @IBOutlet weak var lblcompagnie: UILabel!
    @IBOutlet var txtUserName: LoginRegisterTxtField!
    @IBOutlet var txtEmail: LoginRegisterTxtField!
    @IBOutlet var txtConfirmPassword: LoginRegisterTxtField!
    @IBOutlet var txtPassword: LoginRegisterTxtField!
    @IBOutlet var txtMobileNo: LoginRegisterTxtField!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var lblSignInWith: setTextLabel!
    @IBOutlet var txtSalutation: TextfieldPicker!
    @IBOutlet var txtDriverType: TextfieldPicker!
    
    @IBOutlet var txtLastName: LoginRegisterTxtField!
    @IBOutlet var txtComapyName: LoginRegisterTxtField!
    @IBOutlet var txtCompanyAddress: LoginRegisterTxtField!
    @IBOutlet var txtCompanyZipCode: LoginRegisterTxtField!
    @IBOutlet var txtCompanySiret: LoginRegisterTxtField!
    @IBOutlet var txtCompanyVAT: LoginRegisterTxtField!
    @IBOutlet var LicenseNumber: LoginRegisterTxtField!
    @IBOutlet var txtDriverTypeDocNumber: LoginRegisterTxtField!
    
    @IBOutlet var txtCode: TextfieldPicker!
    @IBOutlet var btnImg: UIButton!
    let arrSatutation : NSMutableArray = NSMutableArray()
    let arrDriverType : NSMutableArray = NSMutableArray()
    let arrDriverTypeId : NSMutableArray = NSMutableArray()
    let arrCode : NSMutableArray = NSMutableArray()
    let arrCodeId : NSMutableArray = NSMutableArray()
    let arrCountoryName : NSMutableArray = NSMutableArray()
    var List : RootList!
    var salutation : SalutationModel!
    var driverType : DriverType!
    var code : CodeModel!
    var otpTxtField: UITextField!
    var userId:String!
    var emailExist : EmailExist!
    var strDriverImg : String = ""
    var actionSheet: UIActionSheet!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
        getSalutation()
        //getDriverType()
        getCode()
        //txtDriverType.delegateTextField = self
        
        btnImg.layer.cornerRadius = 40
        btnImg.clipsToBounds = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        if actionSheet != nil{
            actionSheet.dismiss(withClickedButtonIndex: 2, animated: false)
        }
        
    }
    @IBAction func backBtnPress(_ sender: UIBarButtonItem)
    {
        self.navigationController?.popViewController(animated: true)
    }
    func setUpView()  {
        // manage strings to multi language
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.title = NikkosDriverManager.GetLocalString("Register")
        
        txtSalutation.placeholder = "Salutation"
        
        txtUserName.placeholder = "First Name"
        
        txtLastName.placeholder = NikkosDriverManager.GetLocalString("Enter_your_lastname")
        
        txtEmail.placeholder = NikkosDriverManager.GetLocalString("Enter_Your_Email")
        
        txtPassword.placeholder = NikkosDriverManager.GetLocalString("Enter_your_password")
        
        txtConfirmPassword.placeholder = NikkosDriverManager.GetLocalString("Enter_Your_Confirm_Password")
        
        txtMobileNo.placeholder = NikkosDriverManager.GetLocalString("Enter_Your_Phone_No")
        NikkosDriverManager.getToolBar(self, inputView: txtMobileNo, selecter: #selector(doneWithNumberPad))
        
        txtCode.placeholder = NikkosDriverManager.GetLocalString("Code")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func doneWithNumberPad()
    {
        self.view.endEditing(true)
    }
    
    // get gender
    func getSalutation(){
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "GetSalutation"), parameter: [:], httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrSatutation.removeAllObjects()
                    let tempArr = ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        self.salutation = SalutationModel(fromDictionary: dict as NSDictionary)
                        self.arrSatutation .add(self.salutation.text)
                    }
                    self.txtSalutation.reloadPickerWithArray(self.arrSatutation)
                    
                }
                else
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
    
    //get ph. code
    func getCode(){
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "CountryList"), parameter: [:], httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrCode.removeAllObjects()
                    self.arrCodeId.removeAllObjects()
                    self.arrCountoryName.removeAllObjects()
                    let tempArr = ((data?.value(forKey: "Data") as! NSDictionary).value(forKey: "List")) as!  [[String:AnyObject]]
                    for dict in tempArr
                    {
                        self.code = CodeModel(fromDictionary: dict as NSDictionary)
                        self.arrCode .add(self.code.code)
                        self.arrCodeId.add(self.code.countryId)
                        self.arrCountoryName.add(self.code.name)
                        
                    }
                    // self.txtCode.reloadPickerWithArray(self.arrCode)
                    self.txtCode.reloadPickerWithArrayArray(self.arrCode, arrName: self.arrCountoryName)
                }
                else
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
    // sign up process
    @IBAction func SignUpBtnPress(_ sender: AnyObject) {
        self.view.endEditing(true)
        if ValidateEntries() == false {
            return
        }
        var driverId : String!
        var registerService : String!
        
        if self.emailExist.isUserActive == true{
            if self.emailExist.isDriverActive == false{
                registerService =  String(NikkosDriverManager.k_Common + "UpdateDriverProfile")
            }else{
                registerService =  String(NikkosDriverManager.k_Common + "DriverRegistration")
            }
            driverId = String(describing: SharedStorage.getDriverId())
        }else{
            registerService =  String(NikkosDriverManager.k_Common + "DriverRegistration")
            driverId = "0"
        }
        let userRole : String = "2"
        let deviceType : String = "1"
        
        if strDriverImg == nil || strDriverImg == "update"
        {
            strDriverImg = ""
        }
        let index = arrCode .index(of: txtCode.text!)
        let codeId = arrCodeId .object(at: index)
        let parameters: [String: AnyObject] = [
            "ProfileImage"  : strDriverImg as AnyObject,
            "Salutation"    : NikkosDriverManager.trimString(txtSalutation.text!) as AnyObject,
            "FirstName"     : NikkosDriverManager.trimString(txtUserName.text!) as AnyObject,
            "LastName"      : NikkosDriverManager.trimString(txtLastName.text!) as AnyObject,
            "Email"         : NikkosDriverManager.trimString(txtEmail.text!) as AnyObject,
            "Password"      : NikkosDriverManager.trimString(txtPassword.text!) as AnyObject,
            "CountryId"     : codeId as AnyObject,
            "PhoneNumber"   : NikkosDriverManager.trimString(txtMobileNo.text!) as AnyObject,
            "DeviceToken"   : SharedStorage.getDeviceToken() as AnyObject,
            "DeviceType"    : deviceType as AnyObject,
            "UserRole"      : userRole as AnyObject,
            "DriverId"      : driverId as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(registerService, parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.emailExist = EmailExist(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    SharedStorage.setDriverId(self.emailExist.driverId! as NSNumber)
                    
                    let id = String(self.emailExist.driverId)
                    if id != "0" {
                        let loginModel : LoginModal = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                        SharedStorage.setDriverId(loginModel.driverId! as NSNumber)
                        SharedStorage.setUser(loginModel)
                    }
                    
                    if self.emailExist.isUserActive == true{
                        if self.emailExist.isDriverActive == false{
                            if self.emailExist.hasDriverDocAdded == false{
                                CIError(data?.value(forKey: "ResponseMessage") as! String)
                                
                                let addMyDoc = self.storyboard?.instantiateViewController(withIdentifier: "addMyDoc") as? AddMyDocumentsViewController
                                addMyDoc!.isFromRegistratinVC = true
                                self.navigationController?.pushViewController(addMyDoc!, animated: true)
                            }
                            else if self.emailExist.hasVehicleAdded == false{
                                CIError(data?.value(forKey: "ResponseMessage") as! String)
                                let addCarVC = self.storyboard?.instantiateViewController(withIdentifier: "addCarVC") as? AddCarViewController
                                addCarVC!.isFromRegistratinVC = true
                                addCarVC!.isFromMyCar = false
                                addCarVC!.hasVehicleDocAdd = false
                                self.navigationController?.pushViewController(addCarVC!, animated: true)
                            }
                            else if self.emailExist.hasVehicleDocAdded == false{
                                CIError(data?.value(forKey: "ResponseMessage") as! String)
                                let addCarVC = self.storyboard?.instantiateViewController(withIdentifier: "addCarVC") as? AddCarViewController
                                addCarVC!.isFromRegistratinVC = true
                                addCarVC!.isFromMyCar = true
                                addCarVC!.hasVehicleDocAdd = true
                                self.navigationController?.pushViewController(addCarVC!, animated: true)
                            }
                            else if self.emailExist.isEmailVerified == false{
                                CIError("Please verify your email address.")
                                self.navigationController?.popViewController(animated: true)
                            }
                            else if self.emailExist.isPhoneVerified == false{
                                self.userId = String(self.emailExist.driverId)
                                self.showOtpAlert()
                            }else{
                                CIError("Please wait for the administrator's approval. You will receive an email after approval.")
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                        }else{
                            CIError(data?.value(forKey: "ResponseMessage") as! String)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    else
                    {
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                    }
                }
                else
                {
                    
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                
            }else{
                CIError("OOPs something went wrong.")
            }
        }
        
    }
    func showOtpAlert()
    {
        let newWordPrompt = UIAlertController(title: "Verfication?", message: "Enter OTP code!", preferredStyle: UIAlertControllerStyle.alert)
        newWordPrompt.addTextField(configurationHandler: self.addTextField)
         newWordPrompt.addAction(UIAlertAction(title: "OK" , style: UIAlertActionStyle.default, handler: self.wordEntered))
        
        self.present(newWordPrompt, animated: true, completion: nil)
    }
    func wordEntered(_ alert: UIAlertAction!){
        // store the new word
        print(otpTxtField.text)
        self.submitOtp()
        
    }
    
    
    func addTextField(_ textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "OTP"
        textField.keyboardType = UIKeyboardType.numberPad
        otpTxtField = textField
    }
    // send OTP
    func submitOtp()
    {
        if otpTxtField.text?.characters.count == 0 {
            return
        }
        let parameters: [String: AnyObject] =
            [
                "OtpValue"   : self.otpTxtField.text! as AnyObject,
                "DriverId"      : self.userId as AnyObject,
                ]
        
        NikkosDriverManager.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "VerifyDriverLoginOTP"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosDriverManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.navigationController?.popViewController(animated: true)
                }else
                {
                    self.showOtpAlert()
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
                self.showOtpAlert()
            }
            
        }
        
    }
    
    @IBAction func FBBtnPress(_ sender: AnyObject) {
    }
    
    @IBAction func GoogleBtnPress(_ sender: AnyObject) {
    }
    
    //MARK :- Validation
    func ValidateEntries() -> Bool {
        
        if strDriverImg.count == 0 {
            
            CIError("Please select image.")
            return false
        }
        else if NikkosDriverManager.trimString((txtSalutation?.text)!).isEmpty == true
        {
            CIError("Please select salutation")
            return false
        }
        else if NikkosDriverManager.trimString((txtUserName?.text)!).isEmpty == true
        {
            CIError("Please enter first name")
            return false
        }
        else if NikkosDriverManager.trimString((txtLastName?.text)!).isEmpty == true
        {
            CIError("Please enter last name")
            return false
        }

        else if NikkosDriverManager.trimString((txtEmail?.text)!).isEmpty == true
        {
            CIError("Please enter email")
            return false
        }
        else if NikkosDriverManager.isValidEmail((txtEmail?.text)!) == false
        {
            CIError("Please enter valid email address")
            return false
        }
        else if NikkosDriverManager.trimString((txtPassword?.text)!).isEmpty == true
        {
            CIError("Please enter password")
            return false
        }
        else if NikkosDriverManager.trimString((txtConfirmPassword?.text)!).isEmpty == true
        {
            CIError("Please enter confirm password")
            return false
        }
        else if NikkosDriverManager.trimString((txtPassword?.text)!) != NikkosDriverManager.trimString((txtConfirmPassword?.text)!){
            CIError("Password and confirm password does not match")
            return false
        }
        else if txtPassword.text?.count < 6{
            CIError("Password should be minimum of 6 characters")
            return false
        }
        else if txtCode?.text!.isEmpty == true
        {
            CIError("Please enter code.")
            return false
        }
        else if NikkosDriverManager.trimString((txtMobileNo?.text)!).isEmpty == true
        {
            CIError("Please enter phone number")
            return false
        }
        else{
            return true
        }
        
    }
    //text Field with selected value
    func textField(_ textField: UITextField!, didClickedOnDoneButtonWith selectedValue: String)
    {
        print(selectedValue)
        if selectedValue == "TAXI" {
            txtDriverTypeDocNumber.placeholder = NikkosDriverManager.GetLocalString("Enter_Taxi_Number")
        }else if selectedValue == "CAPA"{
            txtDriverTypeDocNumber.placeholder = NikkosDriverManager.GetLocalString("Enter_CAPA_Number")
        }else{
            txtDriverTypeDocNumber.placeholder = NikkosDriverManager.GetLocalString("Enter_EVCT_Number")
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtEmail {
            checkEmailAlreadyRegister()
            return false
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        if textField == txtEmail {
            checkEmailAlreadyRegister()
        }
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        if ReachabilityForInternet.isConnectedToNetwork(){
            txtSalutation.isUserInteractionEnabled = true
            return true
        }else{
            txtSalutation.isUserInteractionEnabled = false
            return false
        }
    }
    // checking email registerd already
    func checkEmailAlreadyRegister(){
        
        if ValidateForEmail() == false {
            return
        }
        
        let parameters: [String: AnyObject] =
            [
                "Email"   : txtEmail.text! as AnyObject,
                ]
        
        NikkosDriverManager.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "CheckDriverEmailExists"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            NikkosDriverManager.dissmissHud()
            if status == true
            {
                
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    //self.clearAllTabs()
                    self.emailExist = EmailExist(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    let id = String(self.emailExist.driverId)
                    

                    
                    if id != "0" {
                        SharedStorage.setDriverId(self.emailExist.driverId! as NSNumber)
                        
                        
                        let loginModel : LoginModal = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                        SharedStorage.setDriverId(loginModel.driverId! as NSNumber)
                        SharedStorage.setUser(loginModel)
                    }
                    
                    if self.emailExist.isUserActive == true{
                        self.setValueBehalfOfEmail()
                    }
                    
                    self.view.endEditing(true)
                    
                }else
                {
                    self.txtEmail.text = ""
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    // Set value for UI
    func setValueBehalfOfEmail(){
        txtSalutation.text = self.emailExist.salutation
        txtUserName.text = self.emailExist.firstName
        if self.emailExist.lastName != nil{
            txtLastName.text = self.emailExist.lastName
        }
        txtEmail.text = self.emailExist.email
        txtMobileNo.text = self.emailExist.phoneNumber
        
        let codeId = arrCodeId .index(of: self.emailExist.countryId)
        let code = arrCode .object(at: codeId)
        txtCode.text =  String(describing: code)
        
        //download imageurl
        if String(self.emailExist.profileImage) != nil{
            let imgURL = URL(string: self.emailExist.profileImage)
            let request: URLRequest = URLRequest(url: imgURL!)
            
            NSURLConnection.sendAsynchronousRequest(
                request, queue: OperationQueue.main,
                completionHandler: {(responseData, response, error) -> Void in
                    if error == nil {
                        // self.image_element.image = UIImage(data: data)
                        self.btnImg.setImage(UIImage(data: response!), for: UIControlState())
                        self.strDriverImg = "update"
                    }
                    })
            strDriverImg = ""
        }
    }
    // clear data
    func clearAllTabs(){
        txtSalutation.text = ""
        txtUserName.text = ""
        txtLastName.text = ""
        txtEmail.text = ""
        txtPassword.text = ""
        txtConfirmPassword.text = ""
        txtMobileNo.text = ""
    }
    
    @IBAction func imgUploadBtnPress(_ sender: AnyObject) {
        self.view.endEditing(true)
        imageTap()
    }
    func imageTap() {
        
        actionSheet = UIActionSheet(title: "Select an option.", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take from Camera", "Take from Album")
        actionSheet.tag = 10
        actionSheet.show(in: self.view)
        
        
    }
    // MARK:-UIAction sheet delegates
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        let imagPicker : UIImagePickerController = UIImagePickerController()
        if buttonIndex == 1 {
            let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if authStatus != .authorized {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted: Bool) -> Void in
                })
            }
            else {
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async(execute: {
                        let imgPicker = UIImagePickerController()
                        imgPicker.delegate = self
                        imgPicker.allowsEditing = false
                        imgPicker.sourceType = .camera
                        self.present(imgPicker, animated: true, completion: {() -> Void in
                            //              NSLog(@"SourceTypeCamera");
                        })
                        
                    })
                }
            }
        }
        else if buttonIndex == 2 {
            
            if PHPhotoLibrary.authorizationStatus() != .authorized {
                
                PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus) in
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    let imgPicker = UIImagePickerController()
                    imgPicker.delegate = self
                    imgPicker.allowsEditing = false
                    imgPicker.sourceType = .photoLibrary
                    self.present(imgPicker, animated: true, completion: {() -> Void in
                        //              NSLog(@"SourceTypeCamera");
                    })
                    
                })
            }
        }
        
    }
    
    // MARK: - imagePickerController delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        strDriverImg = getStingFromImg(pickedImage!) as String
        btnImg.setImage(pickedImage, for: UIControlState())
        dismiss(animated: true, completion: nil)
        
    }
    //cnvert 64string from image
    func getStingFromImg(_ image :UIImage) -> NSString{
        let image : UIImage = image
        if let imageData = image.jpeg(.lowest) {
            print(imageData.count)
            let strBase64:String =  imageData.base64EncodedString(options: .lineLength64Characters)
            return strBase64 as NSString
        }
        return ""
        //        let imageData:Data = UIImageJPEGRepresentation(image, 0.5)!
        //        let strBase64:String =  imageData.base64EncodedString(options: .lineLength64Characters)
        //        return strBase64 as NSString
    }
    
    func ValidateForEmail() -> Bool {
        if NikkosDriverManager.trimString((txtEmail?.text)!).isEmpty == true
        {
            CIError("Please enter email address.")
            return false
        }
        else if NikkosDriverManager.isValidEmail((txtEmail?.text)!) == false
        {
            CIError("Please enter valid email address.")
            return false
        }
        else{
            return true
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
