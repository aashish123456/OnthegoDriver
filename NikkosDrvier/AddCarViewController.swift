//
//  AddCarViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 07/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AddCarViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet var btnAddDocForVehicle: UIButton!
    @IBOutlet var lblVehicleStatus: UILabel!
    @IBOutlet var lblAddVehiclePic: UILabel!
    @IBOutlet var txtEnterVIN: LoginRegisterTxtField!
    @IBOutlet var txtEnterModelYr: TextFieldYearPicker!
    @IBOutlet var txtEnterPlateNo: LoginRegisterTxtField!
    @IBOutlet var btnVehicleStatus: UIButton!
    @IBOutlet var txtAllVehicleCat: TextfieldPicker!
    @IBOutlet var txtMake: LoginRegisterTxtField!
    @IBOutlet var txtVehicleModel: LoginRegisterTxtField!
    @IBOutlet var txtPassengerCapacity: TextFieldNumberPad!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet var statusButton: UIBarButtonItem!
    
    var selectedImg : NSMutableArray = NSMutableArray()
    var arrImageWithId : NSMutableArray = NSMutableArray()
    var arrImageVehicleList : NSMutableArray = NSMutableArray()
    var arrAllVehicleCatData : NSMutableArray = NSMutableArray()
    var arrVehicleCatId : NSMutableArray = NSMutableArray()
    var carModel : MyCar!
    var vehicleList : VehicleList!
    var allVehicleCat : AllVehicleCat!
    var isFromMyCar : Bool!
    var imgPreview : AsyncImageView!
    var vehicleStatus : Int = 0
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromRegistratinVC : Bool!
    var hasVehicleDocAdd : Bool!
    var arrListData : NSMutableArray = NSMutableArray()
    var actionSheet: UIActionSheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        
        self.title = NikkosDriverManager.GetLocalString("Add_Car")
        //txtEnterVIN.placeholder = NikkosDriverManager.GetLocalString("Enter_VIN")
        txtEnterModelYr.placeholder = "Model Year"
        txtEnterPlateNo.placeholder = "Plate Number"
        //txtAllVehicleCat.placeholder = NikkosDriverManager.GetLocalString("Enter_VehicleCat")
        txtMake.placeholder = "Make"
        txtVehicleModel.placeholder = "Car Model"
        //txtPassengerCapacity.placeholder = NikkosDriverManager.GetLocalString("Enter_Passenger")
        //txtEnterVIN.setLeftImage("")
        txtEnterPlateNo.setLeftImage("")
        txtMake.setLeftImage("")
        txtVehicleModel.setLeftImage("")
        //txtPassengerCapacity.setLeftImage("")
        self.setLeftImage("",txtField: txtEnterModelYr)
        //self.setLeftImage("",txtField: txtAllVehicleCat)
        btnAddDocForVehicle.titleLabel?.text = NikkosDriverManager.GetLocalString("Add_Doc_For_Vehicle")
        lblVehicleStatus.text = NikkosDriverManager.GetLocalString("Vehicle_Status")
        lblAddVehiclePic.text = NikkosDriverManager.GetLocalString("Add_Vehicle_Pic")
        btnAddDocForVehicle.isUserInteractionEnabled = true
        if isFromRegistratinVC == true{
            self.navigationItem.hidesBackButton = true
            if hasVehicleDocAdd == true{
                getCarDetialList()
            }
        }else{
            if isFromMyCar == true{
                setValue()
            }
        }
        
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getAllCustomVehicleCategory()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        if actionSheet != nil{
            actionSheet.dismiss(withClickedButtonIndex: 2, animated: false)
        }
        
    }
    func setLeftImage(_ imageName: String, txtField : UITextField)  {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 22, height: 21))
        let image = UIImage(named:imageName);
        imageView.image = image;
        imageView.frame = imageView.frame.insetBy(dx: -10, dy: 0);
        imageView.contentMode = UIViewContentMode.center
        txtField.leftViewMode = UITextFieldViewMode.always
        txtField.leftView = imageView;
        
    }
    
    
    
    func setValue()  {
        //txtEnterVIN.text = vehicleList.vIN
        txtEnterModelYr.text = String(vehicleList.manufacturingYear)
        txtEnterPlateNo.text = vehicleList.plateNumber
        //txtPassengerCapacity.text = String(vehicleList.passengerCapacity)
        txtMake.text = vehicleList.make
        txtVehicleModel.text = vehicleList.vehicleModel
        //txtAllVehicleCat.text = vehicleList.vehicleCategoryName
        //txtEnterVIN.isUserInteractionEnabled = false
        txtEnterModelYr.isUserInteractionEnabled = false
        txtEnterPlateNo.isUserInteractionEnabled = false
        //txtPassengerCapacity.isUserInteractionEnabled = false
        txtMake.isUserInteractionEnabled = false
        txtVehicleModel.isUserInteractionEnabled = false
        //txtAllVehicleCat.isUserInteractionEnabled = false
        for dic in vehicleList.images as [Image] {
            selectedImg.add(dic.imageString)
        }
        if vehicleList.isActive == true{
            btnVehicleStatus.isSelected = true
            vehicleStatus = 1
        }else if vehicleList.isActive == false{
            btnVehicleStatus.isSelected = false
            vehicleStatus = 0
        }
        self.collectionView.reloadData()
        
            if self.vehicleList.hasVehicleDocUploaded == true{
                btnAddDocForVehicle.isHidden = true
            }
    }
    func getCarDetialList()  {
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
                    let vehicleListAllData = data?.value(forKey: "Data") as! NSDictionary
                    let arrList  = vehicleListAllData.value(forKey: "List") as! NSArray
                    var vehicleListAllDataM : VehicleList!
                    for  object  in arrList{
                        vehicleListAllDataM =  VehicleList(fromDictionary: object as! NSDictionary)
                        self.arrListData .add(vehicleListAllDataM)
                    }
                    self.vehicleList = self.arrListData .object(at: 0) as! VehicleList
                    self.setValue()
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
    
    func getAllCustomVehicleCategory(){
        let parameters: [String: AnyObject] = ["" : "" as AnyObject]
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Vehicle + "AllCustomVehicleCategory"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    let allVehicleDict = data?.value(forKey: "Data") as! NSDictionary
                    let arrList  = allVehicleDict.value(forKey: "List") as! NSArray
                    self.arrAllVehicleCatData.removeAllObjects()
                    self.arrVehicleCatId.removeAllObjects()
                    for  object  in arrList{
                        self.allVehicleCat =  AllVehicleCat(fromDictionary: object as! NSDictionary)
                        self.arrAllVehicleCatData .add(self.allVehicleCat.text)
                        self.arrVehicleCatId .add(self.allVehicleCat.value)
                    }
                    print(self.arrAllVehicleCatData)
                    //self.txtAllVehicleCat.reloadPickerWithArray(self.arrAllVehicleCatData)
                    
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
    @IBAction func btnVehicleStatusPress(_ sender: AnyObject) {
        btnVehicleStatus.isSelected = !btnVehicleStatus.isSelected
        if btnVehicleStatus.isSelected {
            vehicleStatus = 1
        }else{
            vehicleStatus = 2
        }
    }
    
    @IBAction func btnAddDocumentVehicle(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if isFromRegistratinVC == true{
            if hasVehicleDocAdd == true{
                self.vehicleList = self.arrListData .object(at: 0) as! VehicleList
                self.performSegue(withIdentifier: "MyCarDoc", sender: self.vehicleList)
                return
            }
        }
        
        if isFromMyCar == true{
            if self.vehicleList.hasVehicleDocUploaded == false{
                self.performSegue(withIdentifier: "MyCarDoc", sender: self.vehicleList)
                return
            }else{
                CIError("already Verified")
                btnAddDocForVehicle.isUserInteractionEnabled = false
                return
            }
            
        }
        
        var id : String!
        var idCapa : String!
        id = String(describing: SharedStorage.getDriverId())
        
        
        if ValidateEntries() == false {
            return
        }
        let  imgArr = createImageArr()
//        let index = arrAllVehicleCatData .index(of: txtAllVehicleCat.text!)
//        let vehicleCatId = arrVehicleCatId .object(at: index)
 //       print(vehicleCatId)
        
        let parameters: [String: AnyObject] = [
            "CompanyId"     : "" as AnyObject,
            "DriverId"     :  id as AnyObject,
            "VIN"   : "" as AnyObject,
            "VehicleCategoryId"     :  "" as AnyObject,
            "ManufacturingYear"  : NikkosDriverManager.trimString(txtEnterModelYr.text!) as AnyObject,
            "PlateNumber"     : NikkosDriverManager.trimString(txtEnterPlateNo.text!) as AnyObject,
            "Images" : imgArr as AnyObject,
            "VehicleStatus" : "" as AnyObject,
            "Make" : NikkosDriverManager.trimString(txtMake.text!) as AnyObject,
            "VehicleModel" : NikkosDriverManager.trimString(txtVehicleModel.text!) as AnyObject,
            "PassengerCapacity" : "" as AnyObject
        ]
        // print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Vehicle + "AddVehicle"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    let carDict = data?.value(forKey: "Data") as! NSDictionary
                    self.carModel =  MyCar(fromDictionary: carDict)
                    self.hasVehicleDocAdd = false
                    self.performSegue(withIdentifier: "MyCarDoc", sender: self.carModel)
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
    
    func createImageArr()->NSArray  {
        
        for i in 0..<selectedImg.count{
            let img = selectedImg.object(at: i)
            let strImg : NSString = getStingFromImg(img as! UIImage)
            let imgDic: [String: String] = [
                "ImageString"      : strImg as String
            ]
            arrImageWithId.add(imgDic)
        }
        return arrImageWithId
    }
    
    //cnvert 64string from image
    func getStingFromImg(_ image :UIImage) -> NSString{
        let image : UIImage = image
        if let imageData = image.jpeg(.lowest) {
            print(imageData.count)
            let strBase64:String =  imageData.base64EncodedString(options: .lineLength64Characters)
            return strBase64 as NSString
        }
        return ""
        //        let imageData:Data = UIImageJPEGRepresentation(image, 0.5)!
        //        let strBase64:String =  imageData.base64EncodedString(options: .lineLength64Characters)
        //        return strBase64 as NSString
    }
    // MARK :- Add image With collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedImg.count<3 {
            if isFromMyCar == true{
                return selectedImg.count
            }else{
                return selectedImg.count + 1;
            }
        }else{
            return 3;
        }
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier : NSString = getReusableIdentifierForIndexPath(indexPath)
        let cell: UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier as String, for: indexPath)
        if reuseIdentifier != "addMoreCell" {
            let aCell : CarAddCollectionViewCell = (cell as! CarAddCollectionViewCell)
            if indexPath.item < selectedImg.count {
                print((string: (selectedImg .object(at: indexPath.row) as AnyObject).description))
                
                if isFromMyCar == true {
                    aCell.imgView.image = nil
                    let img  = String(describing: selectedImg .object(at: indexPath.row))
                    aCell.imgView.imageURL = URL(string:img)
                    aCell.deleteBtn.isHidden = true
                }else{
                    aCell.imgView.image = nil
                    aCell.imgView.image = selectedImg .object(at: indexPath.row) as? UIImage
                    aCell.deleteBtn.tag = indexPath.item
                    aCell.deleteBtn.addTarget(self, action: #selector(removeImage), for: .touchUpInside)
                }
                
                aCell.imgView.layer.cornerRadius = aCell.imgView.frame.size.width / 2
                aCell.imgView.layer.masksToBounds = true
                
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        // handle tap events
        self.view.endEditing(true)
        print("You selected cell #\(indexPath.item)!")
        if isFromMyCar == false {
            if indexPath.item == selectedImg.count {
                if isFromMyCar == false {
                    imageTap()
                }            //isFromList = false
            }
        }else{
            let img : String = selectedImg .object(at: indexPath.row) as! String
            self.performSegue(withIdentifier: "preview", sender: img)
        }
        
        
        
    }
    
    func getReusableIdentifierForIndexPath(_ indexPath:IndexPath) -> NSString {
        if indexPath.item == selectedImg.count  {
            return "addMoreCell";
        }
        else{
            return "addCarImage";
        }
    }
    func removeImage(_ sender :UIButton) {
        //isFromList = false
        selectedImg .removeObject(at: sender.tag)
        collectionView .reloadData()
    }
    
    func imageTap() {
        
        actionSheet  = UIActionSheet(title: "Choose Option.", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Photo Library")
        actionSheet.tag = 10
        actionSheet.show(in: self.view)
        
    }
    
    // MARK:-UIAction sheet delegates
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        let imagPicker : UIImagePickerController = UIImagePickerController()
        //imagPicker.delegate = self
        
        
        
        if buttonIndex == 1 {
            let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
            if authStatus != .authorized {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted: Bool) -> Void in
                })
            }
            else {
                
                
                
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    DispatchQueue.main.async(execute: {
                        let imgPicker = UIImagePickerController()
                        imgPicker.delegate = self
                        imgPicker.allowsEditing = false
                        imgPicker.sourceType = .camera
                        self.present(imgPicker, animated: true, completion: {() -> Void in
                            //              NSLog(@"SourceTypeCamera");
                        })
                        
                    })
                }
            }
        }
        else if buttonIndex == 2 {
            
            
            if PHPhotoLibrary.authorizationStatus() != .authorized {
                
                PHPhotoLibrary.requestAuthorization({(status:PHAuthorizationStatus) in
                })
            }
            else {
                DispatchQueue.main.async(execute: {
                    let imgPicker = UIImagePickerController()
                    imgPicker.delegate = self
                    imgPicker.allowsEditing = false
                    imgPicker.sourceType = .photoLibrary
                    self.present(imgPicker, animated: true, completion: {() -> Void in
                        //              NSLog(@"SourceTypeCamera");
                    })
                    
                })
            }
        }
        
    }
    
    // MARK: - imagePickerController delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        selectedImg .add(pickedImage!)
        collectionView .reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK : - validation
    func ValidateEntries() -> Bool {
        
        if NikkosDriverManager.trimString((txtMake?.text)!).isEmpty == true
        {
            CIError("Please enter make.")
            return false
        }
        else if NikkosDriverManager.trimString((txtVehicleModel?.text)!).isEmpty == true
        {
            CIError("Please enter vehicle model.")
            return false
        }
        else if NikkosDriverManager.trimString((txtEnterModelYr?.text)!).isEmpty == true
        {
            CIError("Please enter model year.")
            return false
        }
        else if NikkosDriverManager.trimString((txtEnterPlateNo?.text)!).isEmpty == true
        {
            CIError("Please enter plate no.")
            return false
        }
        
        else if selectedImg.count == 0 {
            
            CIError("Please select image.")
            return false
        }
        else{
            return true
        }
        
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
        if segue.identifier == "MyCarDoc"
        {
            let myCarDocVC =  segue.destination as! MyCarDocumentViewController
            
            if hasVehicleDocAdd == false{
                myCarDocVC.carModel = sender as! MyCar
            }
            if isFromRegistratinVC == true{
                
                myCarDocVC.isFromRegistratinVC = true
                myCarDocVC.hasVehicleDocAdd = false
                
                if hasVehicleDocAdd == true {
                    myCarDocVC.hasVehicleDocAdd = true
                    myCarDocVC.vehicleList = sender as! VehicleList
                }
            }else{
                if hasVehicleDocAdd == true {
                    myCarDocVC.hasVehicleDocAdd = true
                    myCarDocVC.isFromRegistratinVC = false
                    myCarDocVC.vehicleList = sender as! VehicleList
                }else{
                    myCarDocVC.isFromRegistratinVC = false
                    myCarDocVC.hasVehicleDocAdd = false
                }
                //as
                
            }
            
            
        }else if segue.identifier == "preview"  {
            let previewView = segue.destination as! PreviewViewController
            previewView.strImgURL = sender as! String
        }
    }
    
    
}
