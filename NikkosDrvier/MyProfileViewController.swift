//
//  MyProfileViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 05/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController ,SWRevealViewControllerDelegate,EDStarRatingProtocol,TextFieldPickerDelegate,UITextFieldDelegate{
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var lblRating: UILabel!
    @IBOutlet var lblMyStatus: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var txtMobileNo: LoginRegisterTxtField!
    @IBOutlet var txtDrivingLicense: LoginRegisterTxtField!
    @IBOutlet var txtHeadOfficeAddress: LoginRegisterTxtField!
    @IBOutlet var txtCarRegistrationNo: LoginRegisterTxtField!
    @IBOutlet var imgProfile: AsyncImageView!
    @IBOutlet var switchBtn: UISwitch!
    @IBOutlet var viewStarRating: EDStarRating!
    @IBOutlet var editSaveBtn: UIButton!
    @IBOutlet var txtDriverRang: TextfieldPicker!
    
    @IBOutlet var txtCode: TextfieldPicker!
    @IBOutlet var txtEmail: LoginRegisterTxtField!
    @IBOutlet var statusButton: UIBarButtonItem!
    var bookTripRequestDeatil : BookNowTripRequestDetail!
    var profileModel : ProfileModel!
    var loginObj : LoginModal!
    var model : LoginModal!
    let custNav = CustomNavigationController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var arrDriverRang : NSMutableArray = NSMutableArray()
    var arrRequest : NSMutableArray = NSMutableArray()
    
    //@IBOutlet weak var lblName: UILabel!
    let arrCode : NSMutableArray = NSMutableArray()
    let arrCodeId : NSMutableArray = NSMutableArray()
    let arrCountoryName : NSMutableArray = NSMutableArray()
    var code : CodeModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        txtDriverRang.delegateTextField = self
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        self.title = NikkosDriverManager.GetLocalString("My_Profile")
        arrDriverRang = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30"]
        txtEmail.placeholder = NikkosDriverManager.GetLocalString("Enter_Your_Email")
        txtMobileNo.placeholder = NikkosDriverManager.GetLocalString("Mobile_No")
        NikkosDriverManager.getToolBar(self, inputView: txtMobileNo, selecter: #selector(doneWithNumberPad))
        txtCode.placeholder = NikkosDriverManager.GetLocalString("Code")
        txtDriverRang.placeholder = NikkosDriverManager.GetLocalString("Driver_Range")
        txtDriverRang.reloadPickerWithArray(self.arrDriverRang)
        editSaveBtn.accessibilityLabel = "edit"
        editSaveBtn.setTitle("EDIT", for: .normal)
        self.enableForm(false)
        self.getCode()
        DriverCurrentStatusDetail()
    }
    func doneWithNumberPad()
    {
        self.view.endEditing(true)
    }
    // get code:
    func getCode(){
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "CountryList"), parameter: [:], httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            self.getUserProfile()
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
    // current status
    func DriverCurrentStatusDetail(){
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId(),
            "DeviceToken" : SharedStorage.getDeviceToken() as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "DriverCurrentStatusDetail"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let bookTripRequestData = data?.value(forKey: "Data") as! NSDictionary
                    let arrList  = bookTripRequestData.value(forKey: "List") as! NSArray
                    for  object  in arrList{
                        let getDetail  =  BookNowTripRequestDetail(fromDictionary: object as! NSDictionary)
                        self.arrRequest .add(getDetail)
                    }
                    self.bookTripRequestDeatil =  self.arrRequest.object(at: 0) as! BookNowTripRequestDetail
                }
                //Online Button
                SharedStorage.setIsOnlineOffine(self.bookTripRequestDeatil.isOnline)
                self.custNav.StatusButtonMethod(self.statusButton)
            }
        }
    }
    // profile data
    func getUserProfile()  {
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId(),
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GetDriverProfile"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.loginObj = LoginModal(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    self.setProfileData()
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
    func setProfileData() {
        if self.loginObj.lastName == nil{
            self.loginObj.lastName = ""
        }
        lblName.text = self.loginObj.firstName + self.loginObj.lastName
        imgProfile.imageURL = URL(string:self.loginObj.profileImage)
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.layer.masksToBounds = true
        let codeId = arrCodeId .index(of: self.loginObj.countryId)
        let code = arrCode .object(at: codeId)
        txtCode.text =  String(describing: code)
        txtMobileNo.text = self.loginObj.phoneNumber
        txtEmail.text = self.loginObj.email
        txtDriverRang.text = String(self.loginObj.drivingRange)
        setStarRating()
    }
    func setStarRating() {
        viewStarRating.starImage = UIImage(named: "star_select-1")!
        viewStarRating.starHighlightedImage = UIImage(named: "star_select")!
        viewStarRating.maxRating = 5
        viewStarRating.delegate = self
        viewStarRating.horizontalMargin = 5
        viewStarRating.editable = false
        viewStarRating.rating = Float(self.loginObj.driverRating)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func enableForm(_ flag : Bool){
        txtEmail.isUserInteractionEnabled = flag
        txtMobileNo.isUserInteractionEnabled = flag
        txtDriverRang.isUserInteractionEnabled = flag
        txtCode.isUserInteractionEnabled = flag
    }
    // edit data
    @IBAction func editBtnPress(_ sender: AnyObject) {
        if editSaveBtn.accessibilityLabel == "edit"
        {
            //editSaveBtn.setImage(UIImage(named: "save_icon"), for: UIControlState())
            editSaveBtn.accessibilityLabel = "save"
            editSaveBtn.setTitle("SAVE", for: .normal)
            self.enableForm(true)
        }else
        {
            editProfileData()
        }
    }
    
    func editProfileData()    {
        if ValidateEntries() == false {
            return
        }
        let index = arrCode .index(of: txtCode.text!)
        let codeId = arrCodeId .object(at: index)
        
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "Email"     : txtEmail.text! as AnyObject,
            "CountryId" : codeId as AnyObject,
            "PhoneNumber"     : txtMobileNo.text! as AnyObject,
            "DrivingRange" : txtDriverRang.text! as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "EditDriverProfile"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    self.editSaveBtn.setImage(UIImage(named: "edit_profile"), for: UIControlState())
                    self.editSaveBtn.accessibilityLabel = "edit"
                    self.editSaveBtn.setTitle("EDIT", for: .normal)
                    self.enableForm(false)
                    self.bookTripRequestDeatil = BookNowTripRequestDetail(fromDictionary:(data?.value(forKey: "Data") as! NSDictionary))
                    if self.bookTripRequestDeatil.isDriverActive == false{
                        SharedStorage.setIsRememberMe(false)
                        SharedStorage.setDriverId(0)
                        UserDefaults.standard.set("", forKey: "NC_user")
                        UserDefaults.standard.synchronize()
                        SharedStorage.setUnderCapaDriverId(0)
                        self.appDelegate.loadSignInViewController()
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
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if (textField == txtCode){
            CIError("Please create a new account to change your country")
            return false
        }
        return true
    }
    //MARK: - Validation
    func ValidateEntries() -> Bool {
        
        if NikkosDriverManager.trimString((txtEmail?.text)!).isEmpty == true
        {
            CIError("Please enter email.")
            return false
        }
        else if NikkosDriverManager.isValidEmail((txtEmail?.text)!) == false
        {
            CIError("Please enter valid email address.")
            return false
        }
        else if NikkosDriverManager.trimString((txtMobileNo?.text)!).isEmpty == true
        {
            CIError("Please enter phone number.")
            return false
        }
        else if NikkosDriverManager.trimString((txtDriverRang?.text)!).isEmpty == true
        {
            CIError("Please select Range.")
            return false
        }
        else{
            return true
        }
        
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
