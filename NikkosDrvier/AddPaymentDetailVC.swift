//
//  AddPaymentDetailVC.swift
//  OnthegoDriver
//
//  Created by Ashish Soni on 29/10/18.
//  Copyright © 2018 Dotsquares. All rights reserved.
//

import UIKit

class AddPaymentDetailVC: UIViewController,TextFieldPickerDelegate {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var confirmACViewHeight: NSLayoutConstraint!
    @IBOutlet weak var ConfirmACView: UIView!
    @IBOutlet weak var txtCountryCode: TextfieldPicker!
    @IBOutlet weak var txtBSB: LoginRegisterTxtField!
    @IBOutlet weak var txtConfirmACNumber: LoginRegisterTxtField!
    @IBOutlet weak var txtACNumber: LoginRegisterTxtField!
    
    
    @IBOutlet weak var btnDeleteAC: UIBarButtonItem!
    @IBOutlet weak var btnSave: UIButton!
    let arrCode : NSMutableArray = NSMutableArray()
    let arrCodeId : NSMutableArray = NSMutableArray()
    let arrCountoryName : NSMutableArray = NSMutableArray()
    var code : CodeModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Bank Account"
        
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = false
            button.tintColor = UIColor.clear
        }
        
        self.getCode()
        self.GetBankAccount()
    }
    
    @IBAction func deleteACBtnPress(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Onthego", message: "Are you sure you want to delete this account.", preferredStyle: .alert)
        
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            self.deleteAC()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    func deleteAC(){
        let parameters: [String: AnyObject] = [
            "UserId"     : SharedStorage.getDriverId(),
            ]
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "DeleteBankAccount"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    self.txtACNumber.text = ""
                    self.txtBSB.text = ""
                    self.txtCountryCode.text = ""
                    
                    self.txtACNumber.isUserInteractionEnabled = true
                    self.txtCountryCode.isUserInteractionEnabled = true
                    self.txtBSB.isUserInteractionEnabled = true
                    self.ConfirmACView.isHidden = false
                    self.confirmACViewHeight.constant = 61
                    self.btnSave.isHidden = false
                    
                    if let button = self.navigationItem.rightBarButtonItem {
                        button.isEnabled = false
                        button.tintColor = UIColor.clear
                    }
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
    // get code:
    func getCode(){
       
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "CountryList"),parameter: [:], httpType: "POST") { (status, data, error) -> () in
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
                    self.txtCountryCode.reloadPickerWithArrayArray(self.arrCode, arrName: self.arrCountoryName)
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
    func GetBankAccount() {
        let parameters: [String: AnyObject] = [
            "UserId"     : SharedStorage.getDriverId(),
            ]
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GetBankAccount"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let dic : NSDictionary = data?.value(forKey: "Data") as! NSDictionary
                    self.txtACNumber.text = dic.value(forKey: "AccountNumber") as? String
                    self.txtBSB.text = dic.value(forKey: "RoutingNumber") as? String
                    self.txtCountryCode.text = dic.value(forKey: "CountryCode") as? String
                    self.txtACNumber.isUserInteractionEnabled = false
                    self.txtCountryCode.isUserInteractionEnabled = false
                    self.txtBSB.isUserInteractionEnabled = false
                    self.ConfirmACView.isHidden = true
                    self.confirmACViewHeight.constant = 0
                    self.btnSave.isHidden = true
                    if let button = self.navigationItem.rightBarButtonItem {
                        button.isEnabled = true
                        button.tintColor = UIColor.white
                    }
                }
                else
                {
                   // CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
        }
    }
    

    @IBAction func SaveAccountDetail(_ sender: Any) {
        self.view.endEditing(true)
        if ValidateEntries() == false {
            return
        }
        let index = arrCode .index(of: txtCountryCode.text!)
        let codeId = arrCodeId .object(at: index)
        let parameters: [String: AnyObject] = [
            "UserId"  : SharedStorage.getDriverId() as AnyObject,
            "AccountNumber"    : NikkosDriverManager.trimString(txtACNumber.text!) as AnyObject,
            "RoutingNumber"     : NikkosDriverManager.trimString(txtBSB.text!) as AnyObject,
            "CountryId"   : codeId as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "CreateBankAccount"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.GetBankAccount()
                }
                else
                {
                        CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
                else{
                CIError("OOPs something went wrong.")
            }
        }
        
    }
        
    
    
    //MARK :- Validation
    func ValidateEntries() -> Bool {
        
        if NikkosDriverManager.trimString((txtACNumber?.text)!).isEmpty == true
        {
            CIError("Please enter account number")
            return false
        }
        else if NikkosDriverManager.trimString((txtConfirmACNumber?.text)!).isEmpty == true
        {
            CIError("Please enter confirm account number")
            return false
        }
        else if NikkosDriverManager.trimString((txtACNumber?.text)!) != NikkosDriverManager.trimString((txtConfirmACNumber?.text)!){
            CIError("Account number and confirm account number does not match")
            return false
        }
            
        else if NikkosDriverManager.trimString((txtBSB?.text)!).isEmpty == true
        {
            CIError("Please enter BSB")
            return false
        }
        else if txtCountryCode?.text!.isEmpty == true
        {
            CIError("Please select country code.")
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
