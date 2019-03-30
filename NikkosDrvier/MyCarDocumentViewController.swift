//
//  MyCarDocumentViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 12/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import AVFoundation
import Photos


class MyCarDocumentViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblCardVTC: UILabel!
    @IBOutlet var lblRegistration: UILabel!
    @IBOutlet var lblInsuranceOfVehicle: UILabel!
    @IBOutlet var lblInsurancePro: UILabel!
    @IBOutlet var lblRcPro: UILabel!
    @IBOutlet var lblAddCopiesOfDocuments: setTextLabel!
    @IBOutlet weak var lblAddCopiesOfDocument: UILabel!
    @IBOutlet var statusButton: UIBarButtonItem!
    
    var cardVtc : UIImage!
    var registrationDoc : UIImage!
    var insuranceOfDoc : UIImage!
    var insurancePro : UIImage!
    var RcPro : UIImage!
    var carModel : MyCar!
    var vehicleList : VehicleList!
    var btnIndex : Int = 0
    var isFromRegistratinVC : Bool!
    var hasVehicleDocAdd : Bool!
    var actionSheet: UIActionSheet!
    var arrMyCarDocumentData : NSMutableArray = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NikkosDriverManager.GetLocalString("My_Car")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        lblAddCopiesOfDocument.text = NikkosDriverManager.GetLocalString("Add_copyOfDoc")
        for index in 0...3{
            let dic :[String : AnyObject] = ["Image" : "" as AnyObject, "isUpload" : false as AnyObject]
            arrMyCarDocumentData.insert(dic, at: index)
        }
        
        if isFromRegistratinVC == true{
            self.navigationItem.hidesBackButton = true
        }
        
        self.navigationItem.hidesBackButton = true
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        if actionSheet != nil{
            actionSheet.dismiss(withClickedButtonIndex: 2, animated: false)
        }
        
    }
    //Car doc
    func getDriverDoc(){
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId()
        ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Vehicle + "GetVehicleDoc"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    
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
    //remove Card
    @IBAction func deleteBtnPress(_ sender: AnyObject) {
        cardVtc = nil
    }
    @IBAction func uploadBtnPress(_ sender: AnyObject) {
        let btn = (sender as! UIButton)
        btnIndex = btn.tag
        imageTap()
    }
    func imageTap() {
        actionSheet = UIActionSheet(title: "Select an option.", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Take from Camera", "Take from Album")
        actionSheet.tag = 10
        actionSheet.show(in: self.view)
    }
    
    // MARK:-UIAction sheet delegates
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        let imagPicker : UIImagePickerController = UIImagePickerController()
        imagPicker.delegate = self
        
        
        
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
        let dic :[String : AnyObject] = ["Image" : pickedImage!, "isUpload" : true as AnyObject]
        arrMyCarDocumentData.replaceObject(at: btnIndex, with: dic)
        tblView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnForwardForVerificationPress(_ sender: AnyObject) {
        self.view.endEditing(true)
        
        if hasVehicleDocAdd == true{
            if vehicleList.id == nil{
                return
            }
        }else{
            if carModel.newRecordId == nil{
                return
            }
        }
        if ValidateEntries() == false {
            return
        }
        
        
        let dic1 : NSDictionary = arrMyCarDocumentData.object(at: 0) as! NSDictionary
        let img1 = dic1 .object(forKey: "Image") as! UIImage
        
        let dic2 : NSDictionary = arrMyCarDocumentData.object(at: 1) as! NSDictionary
        let img2 = dic2 .object(forKey: "Image") as! UIImage
        
        let dic3 : NSDictionary = arrMyCarDocumentData.object(at: 2) as! NSDictionary
        let img3 = dic3 .object(forKey: "Image") as! UIImage
        
        let dic4 : NSDictionary = arrMyCarDocumentData.object(at: 3) as! NSDictionary
        let img4 = dic4 .object(forKey: "Image") as! UIImage
        
//        let dic5 : NSDictionary = arrMyCarDocumentData.objectAtIndex(4) as! NSDictionary
//        let img5 = dic5 .objectForKey("Image") as! UIImage
        
        
        let cardVTC = getStingFromImg(img1)
        let registration = getStingFromImg(img2)
        let insurance = getStingFromImg(img3)
//        let insuranceP = getStingFromImg(img4)
//        let RCPro = getStingFromImg(img5)
        let RCPro = getStingFromImg(img4)
        
        var carId : String!
        if hasVehicleDocAdd == true{
            carId =  String(vehicleList.id)
        }else{
            carId = String(carModel.newRecordId)
        }
        
        let parameters: [String: AnyObject] = [
            "VehicleId"     :  carId as AnyObject,
            "Vtc_TransportLicense"   :  cardVTC,
            "Registration"     :  registration,
            "Insurance"  : insurance,
            "InsurancePro"  : RCPro,
            "RcPro"  : RCPro,
            ]
        // print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Vehicle + "AddVehicleDoc"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    self.navigationController?.popToRootViewController(animated: true)
                    
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyCarDocumentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dic : NSDictionary = arrMyCarDocumentData.object(at: indexPath.row) as! NSDictionary
        if dic .object(forKey: "isUpload") as! Bool == false {
            let cell : AddMyDocUploadTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "uploadCell", for: indexPath) as! AddMyDocUploadTableViewCell
            cell.btnUpload.tag = indexPath.item
            cell.btnUpload.addTarget(self, action: #selector(uploadBtn), for: .touchUpInside)
            if indexPath.row == 0{
                cell.lblDocType.text = "Card VTC or transport licene"
            }else if indexPath.row == 1 {
                cell.lblDocType.text = "Registration document"
            }else if indexPath.row == 2 {
                cell.lblDocType.text = "Insurance of the vehicle"
            }
            
//            else if indexPath.row == 3 {
//                cell.lblDocType.text = "Assurance pro"
//            }else if indexPath.row == 4 {
//                cell.lblDocType.text = "RC pro"
//            }
            else if indexPath.row == 3 {
                  cell.lblDocType.text = "RC pro"
             }
            return cell
        }else{
            let cell : AddMyDocPreviewTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "PreviewCell", for: indexPath) as! AddMyDocPreviewTableViewCell
            cell.btnDelete.tag = indexPath.item
            cell.btnPreview.tag = indexPath.item
            cell.btnDelete.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
            cell.btnPreview.addTarget(self, action: #selector(previewBtn), for: .touchUpInside)
            cell.lblDocStatus.text = "Attachment.jpg"
            
            if indexPath.row == 0{
                cell.lblDocType.text = "Card VTC or transport licene"
            }else if indexPath.row == 1 {
                cell.lblDocType.text = "Registration document"
            }else if indexPath.row == 2 {
                cell.lblDocType.text = "Insurance of the vehicle"
            }
//            else if indexPath.row == 3 {
//                cell.lblDocType.text = "Assurance pro"
//            }else if indexPath.row == 4 {
//                cell.lblDocType.text = "RC pro"
//            }
            else if indexPath.row == 3 {
                 cell.lblDocType.text = "RC pro"
            }
            
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func uploadBtn(_ sender :UIButton)  {
        
        let btn = sender
        btnIndex = btn.tag
        imageTap()
    }
    func deleteBtn(_ sender :UIButton){
        
        let btn = sender
        btnIndex = btn.tag
        let dic :[String : AnyObject] = ["Image" : "" as AnyObject, "isUpload" : false as AnyObject]
        arrMyCarDocumentData.replaceObject(at: btnIndex, with: dic)
        print(arrMyCarDocumentData)
        tblView.reloadData()
    }
    func previewBtn(_ sender :UIButton)  {
        let btn = sender
        btnIndex = btn.tag
        let dic : NSDictionary = arrMyCarDocumentData.object(at: btnIndex) as! NSDictionary
        let img = dic .object(forKey: "Image") as! UIImage
        self.performSegue(withIdentifier: "preview", sender: img)
    }
    
    func ValidateEntries() -> Bool {
        
        let dic1 : NSDictionary = arrMyCarDocumentData.object(at: 0) as! NSDictionary
        let img1 = dic1 .object(forKey: "Image") as? UIImage
        
        let dic2 : NSDictionary = arrMyCarDocumentData.object(at: 1) as! NSDictionary
        let img2 = dic2 .object(forKey: "Image") as? UIImage
        
        let dic3 : NSDictionary = arrMyCarDocumentData.object(at: 2) as! NSDictionary
        let img3 = dic3 .object(forKey: "Image") as? UIImage
        
        let dic4 : NSDictionary = arrMyCarDocumentData.object(at: 3) as! NSDictionary
        let img4 = dic4 .object(forKey: "Image") as? UIImage
        
//        let dic5 : NSDictionary = arrMyCarDocumentData.objectAtIndex(4) as! NSDictionary
//        let img5 = dic5 .objectForKey("Image") as? UIImage
        
        if img1 == nil
        {
            CIError("Please select card VTC or transport licene.")
            return false
        }
        else if img2 == nil
        {
            CIError("Please select registration document.")
            return false
        }
        else if img3 == nil
        {
            CIError("Please select insurance of the vehicle.")
            return false
        }
//        else if img4 == nil{
//            CIError("Veuillez ajouter le document assurance pro.")
//            return false
//        }
//        else if img5 == nil{
//            CIError("Veuillez ajouter le document rc pro.")
//            return false
//        }
        else if img4 == nil{
            CIError("Please select RC pro")
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
        if segue.identifier == "preview" {
            let previewView = segue.destination as! PreviewViewController
            previewView.img = sender as! UIImage
        }
        
    }
    
    
}
