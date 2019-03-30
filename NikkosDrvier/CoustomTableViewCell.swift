//
//  CoustomTableViewCell.swift
//  MoodTracking
//
//  Created by Pulkit on 10/05/16.
//  Copyright © 2016 Vinod Sahu. All rights reserved.
//

import UIKit

class CoustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

class SidebarTableViewCell: UITableViewCell {
    
    
    let Selected_Cell     =    NikkosDriverManager.UIColorFromRGB(255, g: 255, b: 255)
    let UNSelected_Cell   =    NikkosDriverManager.UIColorFromRGB(255, g: 255, b: 255)
    let Selected_Label    =    NikkosDriverManager.UIColorFromRGB(21, g: 165, b: 61)
    let UNSelected_Label  =    NikkosDriverManager.UIColorFromRGB(0, g: 0, b: 0)
    
    @IBOutlet  var lblSideBarCell: UILabel!
    @IBOutlet  var imgSideBarCell: UIImageView!
    
   

    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
    
    func setUpSideBarCellWithDictionary(_ dictSideBarCelldata :NSDictionary,IfCellSelected : Bool)
    {
        
        if IfCellSelected == true
        {
            let strImageName = dictSideBarCelldata.object(forKey: "image_name")
            imgSideBarCell.image = UIImage(named: strImageName! as! String)
            lblSideBarCell.textColor = Selected_Label
            self.backgroundColor = Selected_Cell
            
        }else
        {
            let strImageName = dictSideBarCelldata.object(forKey: "image_name")
             imgSideBarCell.image = UIImage(named: (strImageName! as! String))
            lblSideBarCell.textColor = UNSelected_Label
            self.backgroundColor = UNSelected_Cell
        }
        lblSideBarCell.text = dictSideBarCelldata.object(forKey: "title") as? String
    }
    
    
    
    
    
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class CarDetailTableViewCell: UITableViewCell {
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblCarModelYear: UILabel!
    @IBOutlet var lblCarPlateNumber: UILabel!
    
    @IBOutlet var btnActiveVehicle: UIButton!
    
    
}
class CarAddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var deleteBtn: UIButton!
    @IBOutlet var imgView: AsyncImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
       // imgView.layer.cornerRadius = 25
    }
    
}
class CarNewAddCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imgNewAdd: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
       // imgNewAdd.layer.cornerRadius = 25
    }
}
class MyDocumentTableViewCell: UITableViewCell {
    @IBOutlet var imgCar: UIImageView!
    @IBOutlet var lblCarModel: UILabel!
    @IBOutlet var lblCarModelYear: UILabel!
    @IBOutlet var lblCarPlateNumber: UILabel!
}
class AddMyDocPreviewTableViewCell : UITableViewCell{
    
    @IBOutlet var lblDocType: UILabel!
    @IBOutlet var lblDocStatus: UILabel!
    @IBOutlet var btnPreview: UIButton!
    @IBOutlet var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
class AddMyDocUploadTableViewCell : UITableViewCell{
    
    @IBOutlet var lblDocStatus: UILabel!
    @IBOutlet var lblDocType: UILabel!
    @IBOutlet var btnUpload: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
class AccessTableViewCell : UITableViewCell{
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblPickUpLocation: UILabel!
    @IBOutlet var imgClient: AsyncImageView!
    @IBOutlet var lblStatus: UILabel!
    
}
class MyTripTableViewCell : UITableViewCell{
    
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var companyName: UILabel!
    //@IBOutlet weak var passengerNumber: UILabel!
    @IBOutlet weak var passengerName: UILabel!
    @IBOutlet weak var toAddress: UILabel!
    @IBOutlet weak var dateTimeOfTravel: UILabel!
    @IBOutlet weak var dateTimeOfBooking: UILabel!
    @IBOutlet weak var fromAddress: UILabel!
    @IBOutlet var lblTripId: UILabel!
    @IBOutlet var lblDateTimeOfBooking: UILabel!
    @IBOutlet var lblDateTimeOfTravel: UILabel!
    @IBOutlet var lblFromAddress: UILabel!
    @IBOutlet var lblToAddress: UILabel!
    @IBOutlet var lblPassengerName: UILabel!
    //@IBOutlet var lblPassengerNumber: UILabel!
    @IBOutlet var lblCompanyName: UILabel!
    @IBOutlet var lblPickUpTime: UILabel!
    @IBOutlet var lblCost: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        dateTimeOfBooking.text=NikkosDriverManager.GetLocalString("Date_Time_Of_Booking")
        dateTimeOfTravel.text=NikkosDriverManager.GetLocalString("Date_Time_Of_Travel")
//        fromAddress.text=NikkosDriverManager.GetLocalString("From_Address")
//        toAddress.text=NikkosDriverManager.GetLocalString("To_Address")
        passengerName.text=NikkosDriverManager.GetLocalString("Passenger_Name")
        //passengerNumber.text=NikkosDriverManager.GetLocalString("Passenger_Number")
        companyName.text=NikkosDriverManager.GetLocalString("Company_Name")
        cost.text=NikkosDriverManager.GetLocalString("Cost")
       
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
class CapaCell: UITableViewCell {
    @IBOutlet var imgDriver: AsyncImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumber: UILabel!
}
class LiveGPSCell: UITableViewCell {
    @IBOutlet var imgDriver: AsyncImageView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblNumber: UILabel!
}
class BalanceSheetCell: UITableViewCell {
    
    @IBOutlet var lblTripId: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblParticulars: UILabel!
    @IBOutlet var lblAmount: UILabel!
}
class ReasonTableViewCell : UITableViewCell{
    
    @IBOutlet var lblCancelReason: UILabel!
}
