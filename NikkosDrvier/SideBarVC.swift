//
//  SideBarVC.swift
//  GivaBuzz
//
//  Created by Umang on 6/9/16.
//  Copyright © 2016 Dheeraj Kumar. All rights reserved.
//

import UIKit

class SideBarVC: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet var lblDriverName: UILabel!
    @IBOutlet var lblDriverEmail: UILabel!
    @IBOutlet var imgDriverProfile: UIImageView!
    let custNav = CustomNavigationController()
    var model : LoginModal!
    var arrSidebarCellData: NSMutableArray = NSMutableArray()
    var selectedCell:Int!
    var strForBadgeCount : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        arrSidebarCellData = NSMutableArray(contentsOfFile: Bundle.main.path(forResource: "SideBarServiceProvider", ofType: "plist")!)!
        let loginObj = SharedStorage.getUser()
        //if loginObj.isCapa == false{
            arrSidebarCellData.removeObject(at: 2)
            arrSidebarCellData.removeObject(at: 5)
        //}
        selectedCell = 0
        
        let revealController: SWRevealViewController? = revealViewController()
        revealController?.panGestureRecognizer
        revealController?.tapGestureRecognizer()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let userModel = SharedStorage.getUser()
        let imgStr : String!
        
        imgStr  = userModel.profileImage
        imgDriverProfile.imageURL = URL(string:imgStr)
        imgDriverProfile.layer.cornerRadius = imgDriverProfile.frame.size.width / 2
        imgDriverProfile.layer.masksToBounds = true
        
        let driverName = userModel.firstName
        let driverEmail = userModel.email
        lblDriverName.text = driverName
        lblDriverEmail.text = driverEmail
        
        self.revealViewController().frontViewController.view.isUserInteractionEnabled =  false
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.revealViewController().frontViewController.view.isUserInteractionEnabled =  true
    }
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSidebarCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SidebarTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "sideBarCell", for: indexPath) as! SidebarTableViewCell
        
        
        if (indexPath.row == selectedCell)
        {
            cell.setUpSideBarCellWithDictionary(arrSidebarCellData.object(at: indexPath.row) as! NSDictionary, IfCellSelected: true)
            
        }
        else
        {
            cell.setUpSideBarCellWithDictionary(arrSidebarCellData.object(at: indexPath.row) as! NSDictionary, IfCellSelected: false)
        }
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        selectedCell = indexPath.row;
        tblView.reloadData()
        if indexPath.row == arrSidebarCellData.count-1 {
            let createAccountErrorAlert: UIAlertView = UIAlertView()
            createAccountErrorAlert.delegate = self
            createAccountErrorAlert.title = "Onthego"
            createAccountErrorAlert.message = "Are you sure you want to logout?"
            createAccountErrorAlert.addButton(withTitle: "Cancel")
            createAccountErrorAlert.addButton(withTitle: "Ok")
            createAccountErrorAlert.show()
        }else if indexPath.row == 0
        {
            appDelegate.loadHomeViewController()
        }
        else
        {
            self.performSegue(withIdentifier: (arrSidebarCellData.object(at: indexPath.row) as! NSDictionary).value(forKey: "Segue") as! String, sender: nil)
        }
    }
    
    
    func alertView(_ View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        
        switch buttonIndex
        {
        case 0:
            break;
        case 1:
            
            let parameters: [String: AnyObject] = [
                "UserId"     : SharedStorage.getDriverId(),
                "Role"     : 2 as AnyObject,
                ]
            print(parameters)
            appDelegate.showHud()
            WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_OnlyCommon + "Logout"), parameter: parameters as NSDictionary as NSDictionary, httpType: "POST") { (status, data, error) -> () in
                self.appDelegate.dissmissHud()
                if status == true
                {
                    print(data)
                    if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                    {
                        SharedStorage.setIsRememberMe(false)
                        
                        
                        //Online Button
                       // SharedStorage.setIsOnlineOffine(false)
                       // self.custNav.StatusButtonMethod(nil)
                        SharedStorage.setDriverId(0)
                        
                        UserDefaults.standard.set("", forKey: "NC_user")
                        UserDefaults.standard.synchronize()
                        
                        SharedStorage.setUnderCapaDriverId(0)
                        self.appDelegate.loadSignInViewController()
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
            
            
            
            
            break;
        default:
            break;
            //Some code here..
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
