//
//  AddAccountWithEmailVC.swift
//  OnthegoDriver
//
//  Created by Ashish Soni on 29/11/18.
//  Copyright © 2018 Dotsquares. All rights reserved.
//

import UIKit

class AddAccountWithEmailVC: UIViewController {

    @IBOutlet weak var txtEmail: LoginRegisterTxtField!
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnAddAC: UIButton!
    
    @IBOutlet weak var btnDeleteAC: UIButton!
    //  MARK:- Outlets
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        // Do any additional setup after loading the view.
        
        if let button = self.navigationItem.rightBarButtonItem {
            button.isEnabled = false
            button.tintColor = UIColor.clear
        }
        headingLbl.text = "Add Paypal Account"
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
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "RemovePaypalAuthorization"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            appDelegate.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    
                    self.btnAddAC.isHidden = false
                    self.headingLbl.text = "Add Paypal Account"
                    self.txtEmail.isUserInteractionEnabled = true
                    if let button = self.navigationItem.rightBarButtonItem {
                        button.isEnabled = false
                        button.tintColor = UIColor.clear
                    }
                    self.txtEmail.text = ""
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start out working with the mock environment. When you are ready, switch to PayPalEnvironmentProduction.
        // - For live charges, use PayPalEnvironmentProduction (default).
        // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
        // - For testing, use PayPalEnvironmentNoNetwork.
    }
    func GetBankAccount() {
        let parameters: [String: AnyObject] = [
            "UserId"     : SharedStorage.getDriverId(),
            ]
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GetPaypalAccount"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            appDelegate.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let dic : NSDictionary = data?.value(forKey: "Data") as! NSDictionary
                    self.txtEmail.text = dic.value(forKey: "userEmailId") as? String
                    
                    if let button = self.navigationItem.rightBarButtonItem {
                        button.isEnabled = true
                        button.tintColor = UIColor.white
                    }
                    self.btnAddAC.isHidden = true
                    self.txtEmail.isUserInteractionEnabled = false
                    self.headingLbl.text = "Paypal Account"
                    
                }
                else
                {
                    
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
        }
    }
    
    @IBAction func AddPaypalAccountBtnPress(_ sender: Any) {
        
        
        self.view.endEditing(true)
        
        if NikkosDriverManager.trimString((txtEmail.text)!).isEmpty == true
        {
            CIError("Please enter email address.")
        }else if NikkosDriverManager.isValidEmail((txtEmail.text)!) == false
        {
            CIError("Please enter valid email address.")
        }
        else
        {
                let parameters: [String: AnyObject] = [
                    "UserId"  : SharedStorage.getDriverId() as AnyObject,
                    "AuthorizationCode"    : txtEmail.text as AnyObject,
                    ]
                print(parameters)
                appDelegate.showHud()
                WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "AddPaypalAuthorization"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                    appDelegate.dissmissHud()
                    if status == true
                    {
                        print(data)
                        
                        
                        if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                        {
                            CIError(data?.value(forKey: "ResponseMessage") as! String)
                            self.navigationController?.popViewController(animated: true)
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
