//
//  PaypalVC.swift
//  OnthegoDriver
//
//  Created by Ashish Soni on 27/11/18.
//  Copyright © 2018 Dotsquares. All rights reserved.
//

import UIKit

class PaypalVC: UIViewController {

    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var btnAddAC: UIButton!
    
    @IBOutlet weak var btnDeleteAC: UIButton!
    //  MARK:- Outlets
    var isPayPalAdded = false
    
    
    //  MARK:- Variable Declaration.
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig = PayPalConfiguration() // default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        // Do any additional setup after loading the view.
        btnDeleteAC.isHidden = true
        usernameView.isHidden = true
        
        self.GetBankAccount()
        configurePaypalSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Start out working with the mock environment. When you are ready, switch to PayPalEnvironmentProduction.
        // - For live charges, use PayPalEnvironmentProduction (default).
        // - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
        // - For testing, use PayPalEnvironmentNoNetwork.
        PayPalMobile.preconnect(withEnvironment: PayPalEnvironmentSandbox)
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
                    self.lblUsername.text = dic.value(forKey: "userEmailId") as? String
                    self.btnDeleteAC.isHidden = false
                    self.usernameView.isHidden = false
                    self.btnAddAC.isHidden = true
                }
                else
                {
                    // CIError(data?.value(forKey: "ResponseMessage") as! String)
                    self.btnDeleteAC.isHidden = true
                    self.usernameView.isHidden = true
                    self.btnAddAC.isHidden = false
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
        }
    }
    
    @IBAction func deleteAccountBtnPress(_ sender: Any) {
        
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
                    self.btnDeleteAC.isHidden = true
                    self.usernameView.isHidden = true
                    self.btnAddAC.isHidden = false
                }
                else
                {
                    self.btnDeleteAC.isHidden = false
                    self.usernameView.isHidden = false
                    self.btnAddAC.isHidden = true
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
        }
    }
    //  MARK:- PayPal configuration Settings.
    func configurePaypalSettings() {
        
        // Set up payPalConfig
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "Onthego"
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        
        payPalConfig.payPalShippingAddressOption = .payPal;
        
        print("PayPal iOS SDK Version: \(PayPalMobile.libraryVersion())")
    }
    @IBAction func AddPaypalAccountBtnPress(_ sender: Any) {
        
        print(PayPalMobile.clientMetadataID())
        
        let futurePaymentViewController = PayPalFuturePaymentViewController(configuration: payPalConfig, delegate: self)
        present(futurePaymentViewController!, animated: true, completion: nil)
    }
   func sendAuthorizationToServer(authorization:[AnyHashable: Any], futurePaymentViewController: PayPalFuturePaymentViewController) {
                self.view.endEditing(true)
    
        if let response = authorization["response"] as? [String:Any] {
            if let authCode = response["code"] as? String {
                let parameters: [String: AnyObject] = [
                    "UserId"  : SharedStorage.getDriverId() as AnyObject,
                    "AuthorizationCode"    : authCode as AnyObject,
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
                            futurePaymentViewController.dismiss(animated: true, completion: { () -> Void in
                                CIError(data?.value(forKey: "ResponseMessage") as! String)
                                self.navigationController?.popViewController(animated: true)
                            })
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
//  MARK:- PayPalFuturePaymentDelegate Methods.
extension PaypalVC:PayPalFuturePaymentDelegate {
    
    func payPalFuturePaymentDidCancel(_ futurePaymentViewController: PayPalFuturePaymentViewController) {
        print("PayPal Future Payment Authorization Canceled")
        futurePaymentViewController.dismiss(animated: true, completion: nil)
    }
    
    func payPalFuturePaymentViewController(_ futurePaymentViewController: PayPalFuturePaymentViewController, didAuthorizeFuturePayment futurePaymentAuthorization: [AnyHashable: Any]) {
        print("PayPal Future Payment Authorization Success!")
        
        print(futurePaymentAuthorization.description)
        
        // send authorization to your server to get refresh token.
        // Your code must now send the authorization response to your server.
        self.sendAuthorizationToServer(authorization: futurePaymentAuthorization, futurePaymentViewController: futurePaymentViewController)
    }
}

