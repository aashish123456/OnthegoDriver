//
//  ContactSupportViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 02/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import MessageUI
class ContactSupportViewController: UIViewController, SWRevealViewControllerDelegate,MFMailComposeViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var webView: UIWebView!
    @IBOutlet weak var lblFeelFreeToReach: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    @IBOutlet var txtUserName: LoginRegisterTxtField!
    @IBOutlet var txtEmail: LoginRegisterTxtField!
    @IBOutlet var txtMobileNo: LoginRegisterTxtField!
    
    
    var contactUs : ContactUsModel!
    var bookTripRequestDeatil : BookNowTripRequestDetail!
    let custNav = CustomNavigationController()
    var arrRequest : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.title = NikkosDriverManager.GetLocalString("Contact_Support")
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        
        lblContactUs.text=NikkosDriverManager.GetLocalString("Contact_Us")
        lblFeelFreeToReach.text=NikkosDriverManager.GetLocalString("Feel_Free_To_Reach")
        txtUserName.placeholder = NikkosDriverManager.GetLocalString("Enter_your_username")
        txtUserName.setLeftImage("login_user")
        txtEmail.placeholder = NikkosDriverManager.GetLocalString("Enter_Your_Email")
        txtEmail.setLeftImage("email_icon")
        txtMobileNo.placeholder = NikkosDriverManager.GetLocalString("Enter_Your_Phone_No")
        txtMobileNo.setLeftImage("telephone")
        getContactUS()
        DriverCurrentStatusDetail()
    }
    //Email
    @IBAction func btnEmailPRess(_ sender: AnyObject) {
        
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            //self.present(mailComposeViewController, animated: true, completion: nil)
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([self.txtEmail.text!])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func btnMobilePress(_ sender: AnyObject) {
        
        
        if let url = URL(string: "tel://\(self.txtMobileNo.text!)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.openURL(url)
        }
    }
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
    
    
    func getContactUS()
    {
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Common + "GetContactus"), parameter: [:], httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let contact = data?.value(forKey: "Data") as! NSDictionary
                    self.contactUs = ContactUsModel(fromDictionary:contact) as ContactUsModel
                    self.txtUserName.text = self.contactUs.address
                    self.txtEmail.text = self.contactUs.email
                    self.txtMobileNo.text = self.contactUs.phoneNumber
                }else
                {
                    //CIError(data?.valueForKey("Status") as! String)
                }
            }
            else
            {
                //  CIError("OOPs something went wrong.")
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
