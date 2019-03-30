//
//  LiveGPSViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 02/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class LiveGPSViewController: UIViewController, SWRevealViewControllerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var tblCapa: UITableView!
    
    
    let arrCapaDriversData : NSMutableArray = NSMutableArray()
    var capaDriver : CapaDriver!
    var bookTripRequestDeatil : BookNowTripRequestDetail!
    let custNav = CustomNavigationController()
    var arrRequest : NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosDriverManager.GetLocalString("Live_GPS")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        statusButton.target = self.navigationController
        statusButton.action = #selector(CustomNavigationController.StatusButton(_:))
        
        DriverCurrentStatusDetail()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCapaDriverList()
    }
    func getCapaDriverList() {
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId()
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "CapaDriversList"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrCapaDriversData .removeAllObjects()
                    let capaListData = data?.value(forKey: "Data") as! NSDictionary
                    
                    let arrList  = capaListData.value(forKey: "List") as! NSArray
                    
                    for  object  in arrList{
                        
                        self.capaDriver =  CapaDriver(fromDictionary: object as! NSDictionary)
                        self.arrCapaDriversData .add(self.capaDriver)
                        
                    }
                    self.tblCapa.reloadData()
                    
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
        return arrCapaDriversData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell : LiveGPSCell  = tableView.dequeueReusableCell(withIdentifier: "LiveGPSCell", for: indexPath) as! LiveGPSCell
        let capaDriver = arrCapaDriversData.object(at: indexPath.row) as! CapaDriver
        cell.imgDriver.imageURL = URL(string: capaDriver.profileImage)
        cell.lblName.text = capaDriver.firstName
        cell.lblNumber.text = capaDriver.phoneNumber
        cell.imgDriver.layer.cornerRadius = cell.imgDriver.frame.size.width / 2
        cell.imgDriver.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath)
    {
        
        let capaDriver = arrCapaDriversData.object(at: indexPath.row) as! CapaDriver
        let liveGpsMapView = self.storyboard?.instantiateViewController(withIdentifier: "liveMap") as? LiveGPSMAPViewController
        liveGpsMapView?.underDriverId = String(capaDriver.driverId)
        self.navigationController?.pushViewController(liveGpsMapView!, animated: true)
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
