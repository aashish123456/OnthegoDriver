//
//  MyCarViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 02/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit

class MyCarViewController: UIViewController , UITableViewDelegate , UITableViewDataSource , SWRevealViewControllerDelegate {
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet var tblCar: UITableView!
    @IBOutlet var statusButton: UIBarButtonItem!
    
    var arrListData : NSMutableArray = NSMutableArray()
    var strNavPurpose : NSString!
    var isNavPurpose : Bool!
    var vehicleListModel : VehicleList!
    var selectedIndex : NSInteger = -1
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            sideBarButton.target = self.revealViewController()
            sideBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.title = NikkosDriverManager.GetLocalString("My_Car")
        self.tblCar.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        isNavPurpose = false
        tblCar.reloadData()
        getCarDetial()
    }
    func getCarDetial()  {
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId(),
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Vehicle + "VehicleList"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    self.arrListData .removeAllObjects()
                    let vehicleListData = data?.value(forKey: "Data") as! NSDictionary
                    
                    let arrList  = vehicleListData.value(forKey: "List") as! NSArray
                    
                    for  object  in arrList{
                        self.vehicleListModel =  VehicleList(fromDictionary: object as! NSDictionary)
                        self.arrListData .add(self.vehicleListModel)
                        
                    }
                    
                    self.tblCar.reloadData()
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
    
    func updateVehicleStatus(_ index : Int)  {
        
        let vehicleListData : VehicleList = arrListData .object(at: index) as! VehicleList
        let parameters: [String: AnyObject] = [
            "DriverID"     : SharedStorage.getDriverId(),
            "VehicleID"     : vehicleListData.id as AnyObject,
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Vehicle + "ActiveVehicle"), parameter: parameters as NSDictionary as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    
                }else
                {
                    self.selectedIndex = -1
                    
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                }
                self.getCarDetial()
                
            }
            else
            {
                CIError("OOPs something went wrong.")
            }
            
        }
        
    }
    
    
    func AddCarView() {
        
        self.performSegue(withIdentifier: "AddCar", sender: nil)
    }
    //MARK : - Tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CarDetailTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "carDetail", for: indexPath) as! CarDetailTableViewCell
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        let vehicleListData : VehicleList = arrListData .object(at: indexPath.row) as! VehicleList
        
        if vehicleListData.images.count > 0{
            cell.imgCar.imageURL =  URL(string:vehicleListData.images[0].imageString)
        }
        cell.imgCar.layer.cornerRadius = cell.imgCar.frame.size.width / 2
        cell.imgCar.layer.masksToBounds = true
        
        cell.lblCarModel.text = vehicleListData.vehicleModel
        cell.lblCarModelYear.text = String(vehicleListData.manufacturingYear)
        cell.lblCarPlateNumber.text = vehicleListData.plateNumber
        if vehicleListData.isActive == true{
            selectedIndex = indexPath.row
        }
        
        if selectedIndex == indexPath.row{
            cell.btnActiveVehicle.isSelected = true
            
        }else{
            cell.btnActiveVehicle.isSelected = false
        }
        
        
        cell.btnActiveVehicle.tag = indexPath.item
        cell.btnActiveVehicle.addTarget(self, action: #selector(ActiveVehicle), for: .touchUpInside)
        
        
        
        
        return cell
    }
    func ActiveVehicle(_ sender :UIButton) {
        
        let btn = sender
        btn.isSelected = !btn.isSelected
        let btnIndex = btn.tag
        selectedIndex = btnIndex
        self.updateVehicleStatus(btnIndex)
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        isNavPurpose = true
        let vehicleListData : VehicleList = arrListData .object(at: indexPath.row) as! VehicleList
        self.performSegue(withIdentifier: "AddCar", sender: vehicleListData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addCarVC = segue.destination as! AddCarViewController
        if isNavPurpose == true{
            addCarVC.vehicleList = sender as! VehicleList
            addCarVC.isFromMyCar = true
            //as
            addCarVC.hasVehicleDocAdd = true
        }else{
            addCarVC.isFromMyCar = false
        }
        addCarVC.isFromRegistratinVC = false
    }
    
    
}
