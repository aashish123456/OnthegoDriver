//
//  SettingVC.swift
//  OnthegoDriver
//
//  Created by Ashish Soni on 29/10/18.
//  Copyright © 2018 Dotsquares. All rights reserved.
//

import UIKit

class SettingVC: UIViewController,SWRevealViewControllerDelegate {
    
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
//        statusButton.target = self.navigationController
//        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        
    }

    @IBAction func changePasswordPress(_ sender: Any) {
        
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
    @IBAction func paymentModePress(_ sender: Any) {
        //self.performSegue(withIdentifier: "addAccount", sender: nil)
        //self.performSegue(withIdentifier: "payment", sender: nil)
        self.performSegue(withIdentifier: "emailAC", sender: nil)
        
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
