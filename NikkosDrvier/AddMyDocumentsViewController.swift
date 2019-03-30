//
//  AddMyDocumentsViewController.swift
//  NikkosDrvier
//
//  Created by Ashish Soni on 08/09/16.
//  Copyright © 2016 Dotsquares. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class AddMyDocumentsViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate {
    
    @IBOutlet var tblView: UITableView!
    @IBOutlet var lblDLImgName: UILabel!
    @IBOutlet var lblVtcPdf: UILabel!
    @IBOutlet var lblMedicalPdf: UILabel!
    @IBOutlet var btnPoliceRecord: UIButton!
    @IBOutlet var btnMedicalExamination: UIButton!
    @IBOutlet var btnUpload: UIButton!
    @IBOutlet var statusButton: UIBarButtonItem!
    @IBOutlet weak var btnForwardForVerification: UIButton!
    @IBOutlet weak var lblAddCopiesOfDocuments: UILabel!
    
    var btnIndex : Int = 0
    var myDoc : MyDocument!
    var arrListData : NSMutableArray = NSMutableArray()
    var arrMyDocumentData : NSMutableArray = NSMutableArray()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromRegistratinVC : Bool!
    var actionSheet: UIActionSheet!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title=NikkosDriverManager.GetLocalString("Add_My_Document")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        // Do any additional setup after loading the view.
        for index in 0...2{
            let dic :[String : AnyObject] = ["Image" : "" as AnyObject, "isUpload" : false as AnyObject]
            arrMyDocumentData.insert(dic, at: index)
        }
        getDocumentDetial()
        if isFromRegistratinVC == true{
            self.navigationItem.hidesBackButton = true
        }
        //lblAddCopiesOfDocuments.text=NikkosDriverManager.GetLocalString("Add_Copies_Of_Documents")
        btnForwardForVerification.setTitle(NikkosDriverManager.GetLocalString("Forward_For_Verification"), for: UIControlState())
        
        if self.isFromRegistratinVC == false{
            btnForwardForVerification.isHidden = true
        }else{
            btnForwardForVerification.isHidden = false
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        if actionSheet != nil{
            actionSheet.dismiss(withClickedButtonIndex: 2, animated: false)
        }
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
        let dic :[String : AnyObject] = ["Image" : pickedImage!, "isUpload" : true as AnyObject]
        arrMyDocumentData.replaceObject(at: btnIndex, with: dic)
        tblView.reloadData()
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func btnForwardForVerificationPress(_ sender: AnyObject) {
        if self.isFromRegistratinVC == false{
            return
        }
        self.view.endEditing(true)
        
        if ValidateEntries() == false {
            return
        }
        let dic1 : NSDictionary = arrMyDocumentData.object(at: 0) as! NSDictionary
        let img1 = dic1 .object(forKey: "Image") as! UIImage
        
//        let dic2 : NSDictionary = arrMyDocumentData.object(at: 1) as! NSDictionary
//        let img2 = dic2 .object(forKey: "Image") as? UIImage
        
        let dic2 : NSDictionary = arrMyDocumentData.object(at: 1) as! NSDictionary
        let img2 = dic2 .object(forKey: "Image") as? UIImage
        
        let dic3 : NSDictionary = arrMyDocumentData.object(at: 2) as! NSDictionary
        let img3 = dic3 .object(forKey: "Image") as? UIImage
        
        let license = getStingFromImg(img1)
        var virginPoliceRecord = ""
        var medical = ""
        
        if img2 != nil{
            virginPoliceRecord = getStingFromImg(img2!) as String
        }
        if img3 != nil{
            medical = getStingFromImg(img3!) as String
        }
        
        let id : String!
        id = String(describing: SharedStorage.getDriverId())
        
        let parameters: [String: AnyObject] = [
            "DriverId"     :  id as AnyObject,
            "License"   :  license,
            "VirginPoliceRecord"     :  virginPoliceRecord as AnyObject,
            "Medical"  : medical as AnyObject,
            ]
         //print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "AddDriverDoc"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
            self.appDelegate.dissmissHud()
            if status == true
            {
                print(data)
                if data?.value(forKey: "ResponseCode") as! NSNumber == 200
                {
                    CIError(data?.value(forKey: "ResponseMessage") as! String)
                    let addCarVC = self.storyboard?.instantiateViewController(withIdentifier: "addCarVC") as? AddCarViewController
                    addCarVC?.isFromMyCar = false
                    if self.isFromRegistratinVC == true{
                        addCarVC?.isFromRegistratinVC = true
                        addCarVC?.hasVehicleDocAdd = false
                        
                    }
                    self.navigationController?.pushViewController(addCarVC!, animated: true)
                    
                }else
                {
                    //CIError((data?.value(forKey: "Data") as AnyObject).value(forKey: "Message") as! String)
                    CIError("OOPs something went wrong.")
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
    func getDocumentDetial()  {
        let parameters: [String: AnyObject] = [
            "ID"     : SharedStorage.getDriverId(),
            ]
        print(parameters)
        appDelegate.showHud()
        WebServiceHelper.webServiceCall(String(NikkosDriverManager.k_Driver + "GetDriverDoc"), parameter: parameters as NSDictionary, httpType: "POST") { (status, data, error) -> () in
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
                    if self.arrListData.count == 3 && self.isFromRegistratinVC == false{
                        for index in 0...2{
                            let data : MyDocument = self.arrListData .object(at: index) as! MyDocument
                            let dic :[String : AnyObject] = ["Image" : data.text! as AnyObject, "isUpload" : true as AnyObject]
                            self.arrMyDocumentData.replaceObject(at: index, with: dic)
                        }
                        self.tblView.reloadData()
                    }
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
    
    //MARK :- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMyDocumentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dic : NSDictionary = arrMyDocumentData.object(at: indexPath.row) as! NSDictionary
        if dic .object(forKey: "isUpload") as! Bool == false {
            let cell : AddMyDocUploadTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "uploadCell", for: indexPath) as! AddMyDocUploadTableViewCell
            cell.btnUpload.tag = indexPath.item
            cell.btnUpload.addTarget(self, action: #selector(uploadBtn), for: .touchUpInside)
            cell.lblDocStatus.text = NikkosDriverManager.GetLocalString("Not_Uploaded")
            if indexPath.row == 0{
                cell.lblDocType.text = "Driver's licence"
            }else if indexPath.row == 1 {
                cell.lblDocType.text = "Virgin police record"
            }else{
                cell.lblDocType.text = "Medical examination"
            }
            return cell
        }else{
            let cell : AddMyDocPreviewTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "PreviewCell", for: indexPath) as! AddMyDocPreviewTableViewCell
            
            if isFromRegistratinVC == false{
                cell.btnDelete.isHidden = true
            }else{
                cell.btnDelete.isHidden = false
            }
            cell.btnDelete.tag = indexPath.item
            cell.btnPreview.tag = indexPath.item
            cell.btnDelete.addTarget(self, action: #selector(deleteBtn), for: .touchUpInside)
            cell.btnPreview.addTarget(self, action: #selector(previewBtn), for: .touchUpInside)
            cell.lblDocStatus.text = NikkosDriverManager.GetLocalString("Attachment_Jpg")
            
            if indexPath.row == 0{
                cell.lblDocType.text = "Driver's licence"
            }else if indexPath.row == 1 {
                cell.lblDocType.text = "Virgin police record"
            }else{
                cell.lblDocType.text = "Medical examination"
            }
            return cell
        }
        
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vehicleListData : VehicleList = arrListData .object(at: indexPath.row) as! VehicleList
        self.performSegue(withIdentifier: "AddCar", sender: vehicleListData)
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
        arrMyDocumentData.replaceObject(at: btnIndex, with: dic)
        print(arrMyDocumentData)
        tblView.reloadData()
    }
    func previewBtn(_ sender :UIButton)  {
        let btn = sender
        btnIndex = btn.tag
        let dic : NSDictionary = arrMyDocumentData.object(at: btnIndex) as! NSDictionary
        
        if isFromRegistratinVC == false{
            let img = dic .object(forKey: "Image") as! String
            self.performSegue(withIdentifier: "preview", sender: img)
        }else{
            let img = dic .object(forKey: "Image") as! UIImage
            self.performSegue(withIdentifier: "preview", sender: img)
        }
        
    }
    //MARK:- Validation
    func ValidateEntries() -> Bool {
        
        let dic1 : NSDictionary = arrMyDocumentData.object(at: 0) as! NSDictionary
        let img1 = dic1 .object(forKey: "Image") as? UIImage
        
        let dic2 : NSDictionary = arrMyDocumentData.object(at: 1) as! NSDictionary
        let img2 = dic2 .object(forKey: "Image") as? UIImage
        
        let dic3 : NSDictionary = arrMyDocumentData.object(at: 2) as! NSDictionary
        let img3 = dic3 .object(forKey: "Image") as? UIImage
        
        if img1 == nil
        {
            CIError("Please add driver's licence.")
            return false
        }
      /*  else if img2 == nil
        {
            CIError("Please add virgin police record.")
            return false
        }
        else if img3 == nil
        {
            CIError("Please add medical examination.")
            return false
        }*/
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
        let previewView = segue.destination as! PreviewViewController
        if segue.identifier == "preview" {
            if isFromRegistratinVC == true{
                previewView.img = sender as! UIImage
            }else{
                previewView.strImgURL = sender as! String
                
            }
        }
    }
    
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ quality: JPEGQuality) -> Data? {
        return UIImageJPEGRepresentation(self, quality.rawValue)
    }
}
