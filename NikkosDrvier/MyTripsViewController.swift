//
//  MyTripsViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 02/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class MyTripsViewController: UIViewController, SWRevealViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var lblNoData: UILabel!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var arrMyTripData : NSMutableArray = NSMutableArray()
    var myTripList : MyTrip!
    var capaDriverId : String!
    var bookTripRequestDeatil : BookNowTripRequestDetail!
    let custNav = CustomNavigationController()
    var arrRequest : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NikkosDriverManager.GetLocalString("My_Trips")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        self.tableView.tableFooterView = UIView()
        getMyTripData()
        DriverCurrentStatusDetail()
    }
    // Driver Status
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
    
    //Trip data
    func getMyTripData(){
        let id : String!
        if capaDriverId != nil{
            id = capaDriverId
        }else{
            id = String(describing: SharedStorage.getDriverId())
        }
        let parameters: [String: AnyObject] = [
            "ID"     : id as AnyObject
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "DriverTripHistoryList"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrMyTripData .removeAllObjects()
                    let tripData = data?.value(forKey: "Data") as! NSDictionary
                    
                    let arrList  = tripData.value(forKey: "List") as! NSArray
                    
                    for  object  in arrList{
                        self.myTripList =  MyTrip(fromDictionary: object as! NSDictionary)
                        self.arrMyTripData .add(self.myTripList)
                        
                    }
                    self.tableView.reloadData()
                    
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
    //reason table view
    // MARK: - TableView Delegate
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if arrMyTripData.count == 0
        {
            lblNoData.isHidden = false
        }else
        {
            lblNoData.isHidden = true
        }
        return arrMyTripData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell : MyTripTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "myTripCell", for: indexPath) as! MyTripTableViewCell
        let tripListData : MyTrip = arrMyTripData .object(at: indexPath.row) as! MyTrip
        let tripId = String(tripListData.id)
        cell.lblTripId.text = String("\(NikkosDriverManager.GetLocalString("Trip_Id")):  " + tripId)
        cell.lblDateTimeOfBooking.text = tripListData.bookingTime
        cell.lblDateTimeOfTravel.text = tripListData.tripStartOn
        cell.lblFromAddress.text = tripListData.pickupAddress
        cell.lblToAddress.text = tripListData.dropAddress
        cell.lblPassengerName.text = tripListData.customerName
        //cell.lblPassengerNumber.text = tripListData.phoneNumber
        cell.lblCompanyName.text = tripListData.companyName
        cell.lblCost.text = tripListData.amount
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        let myTripList = arrMyTripData.object(at: indexPath.row) as! MyTrip
        self.performSegue(withIdentifier: "preview", sender: myTripList.tripMap)
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
        let showImg = segue.destination as! PreviewViewController
        showImg.strImgURL = sender as! String
        
    }
    
    
}
