//
//  MyDocumentViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 05/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class MyDocumentViewController: UIViewController, SWRevealViewControllerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var tblDoc: UITableView!
    @IBOutlet var statusButton: UIBarButtonItem!
    
    var imgStr : String!
    var driverName : String!
    var driverEmail : String!
    var myDoc : MyDocument!
    var arrListData : NSMutableArray = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.title = NikkosDriverManager.GetLocalString("My_Doc")
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        let userModel = SharedStorage.getUser()
        imgStr  = userModel.profileImage
        driverName = userModel.firstName
        driverEmail = userModel.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblDoc.reloadData()
        getDocumentDetial()
    }
    //Doc detail
    func getDocumentDetial()  {
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId(),
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GetDriverDoc"), parameter: parameters as NSDictionary as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrListData .removeAllObjects()
                    let driverListData = data?.value(forKey: "Data") as! NSDictionary
                    
                    let arrList  = driverListData.value(forKey: "List") as! NSArray
                    
                    for  object  in arrList{
                        self.myDoc =  MyDocument(fromDictionary: object as! NSDictionary)
                        self.arrListData .add(self.myDoc)
                    }
                    
                    self.tblDoc.reloadData()
                    
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
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  self.arrListData.count == 3{
            return 1
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MyDocumentTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "docDetail", for: indexPath) as! MyDocumentTableViewCell
        cell.imgCar.imageURL = URL(string:imgStr)
        cell.imgCar.layer.cornerRadius = cell.imgCar.frame.size.width / 2
        cell.imgCar.layer.masksToBounds = true
        cell.lblCarModel.text = driverName
        cell.lblCarModelYear.text = driverEmail
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "addDoc", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let addMyDoc = segue.destination as! AddMyDocumentsViewController
        addMyDoc.isFromRegistratinVC = false
        
    }
    
    
}
