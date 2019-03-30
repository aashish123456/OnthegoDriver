//
//  BalanceSheetViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 02/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class BalanceSheetViewController: UIViewController, SWRevealViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var tblBalance : UITableView!
    @IBOutlet var lblTotalCost: UILabel!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblToDate: UILabel!
    @IBOutlet var lblFromDate: UILabel!
    @IBOutlet var btn24: UIButton!
    @IBOutlet var btn7: UIButton!
    @IBOutlet var btnMonth: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTripId: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblParticulars: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    var timePeride : Int = 1
    var bookTripRequestDeatil : BookNowTripRequestDetail!
    let custNav = CustomNavigationController()
    var arrRequest : NSMutableArray = NSMutableArray()
    var arrListData : NSMutableArray = NSMutableArray()
    var balanceSheetModel : BalanceSheetModel!
    var balanceSheetListModel : BalanceSheetListModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosDriverManager.GetLocalString("Balance_Sheet")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        
        getBalanceSheet()
        btn7.setTitle(NikkosDriverManager.GetLocalString("Last_7Days"), for: UIControlState())
        btn24.setTitle(NikkosDriverManager.GetLocalString("Last_24Hours"), for: UIControlState())
        btnMonth.setTitle(NikkosDriverManager.GetLocalString("Last_Month"), for: UIControlState())
        lblFromDate.text=NikkosDriverManager.GetLocalString("From_Date")
        lblToDate.text=NikkosDriverManager.GetLocalString("To_Date")
        
        lblTripId.text=NikkosDriverManager.GetLocalString("Trip_Id")
        lblDate.text=NikkosDriverManager.GetLocalString("Date")
        lblName.text=NikkosDriverManager.GetLocalString("Name")
        lblAmount.text=NikkosDriverManager.GetLocalString("Amount")
        lblParticulars.text="Paid"
        DriverCurrentStatusDetail()
        btn24.isSelected = true
    }
    //Driver Detail
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
    
    //Balance sheet
    func getBalanceSheet(){
        let parameters: [String: AnyObject] = [
            "DriverId"     : SharedStorage.getDriverId(),
            "DurationType" : timePeride as AnyObject
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "BalanceSheet"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrListData .removeAllObjects()
                    let balanceSheetDataList = data?.value(forKey: "Data") as! NSDictionary
                    self.balanceSheetListModel = BalanceSheetListModel(fromDictionary: balanceSheetDataList )
                    self.lblFromDate.text = self.balanceSheetListModel.startDate
                    self.lblToDate.text = self.balanceSheetListModel.endDate
                    let cost : String =  String(format: "%.2f",self.balanceSheetListModel.total)
                    self.lblTotalCost.text = self.balanceSheetListModel.total
                    
                    let arrList  = balanceSheetDataList.value(forKey: "List") as! NSArray
                    
                    for  object  in arrList{
                        self.balanceSheetModel =  BalanceSheetModel(fromDictionary: object as! NSDictionary)
                        self.arrListData .add(self.balanceSheetModel)
                        
                    }
                    self.tblBalance.reloadData()
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
    // MARK :- tableView
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell : BalanceSheetCell  = tableView.dequeueReusableCell(withIdentifier: "BalanceSheetCell", for: indexPath) as! BalanceSheetCell
        let balanceSheet : BalanceSheetModel = arrListData .object(at: indexPath.row) as! BalanceSheetModel
        cell.lblTripId.text = String(balanceSheet.tripId)
        
//        let now = NSDate()
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = balanceSheet.tripDate
//        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
//        cell.lblDate.text = formatter.stringFromDate(now)
        
        let arr = balanceSheet.tripDate.components(separatedBy: "T")
        cell.lblDate.text =  arr[0]
        
        cell.lblName.text = balanceSheet.clientName
        
        cell.lblParticulars.text = balanceSheet.hasPaidToDriver == true ? "Yes" : "No"
        
        cell.lblAmount.text = balanceSheet.amount
        return cell
    }
    
    @IBAction func btnTimePeridePress(_ sender: AnyObject) {
        let btn : UIButton = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.tag == 1 {
            timePeride = 1
            btn7.isSelected = false
            btnMonth.isSelected = false
        }else if btn.tag == 2 {
            timePeride = 2
            btn24.isSelected = false
            btnMonth.isSelected = false
        }else{
            timePeride = 3
            btn7.isSelected = false
            btn24.isSelected = false
        }
        getBalanceSheet()
        
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
