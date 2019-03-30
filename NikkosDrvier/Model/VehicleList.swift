//
//	VehicleList.swift
//
//	Create by admin on 21/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class VehicleList : NSObject, NSCoding{

	var companyId : String!
	var driverId : Int!
	var hasVehicleDocUploaded : Bool!
	var id : Int!
	var images : [Image]!
	var isActive : Bool!
	var isApprove : Bool!
	var make : String!
	var manufacturingYear : Int!
	var passengerCapacity : Int!
	var plateNumber : String!
	var vIN : String!
	var vehicleCategoryName : String!
	var vehicleModel : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		companyId = dictionary["CompanyId"] as? String
		driverId = dictionary["DriverId"] as? Int
		hasVehicleDocUploaded = dictionary["HasVehicleDocUploaded"] as? Bool
		id = dictionary["Id"] as? Int
		images = [Image]()
		if let imagesArray = dictionary["Images"] as? [NSDictionary]{
			for dic in imagesArray{
				let value = Image(fromDictionary: dic)
				images.append(value)
			}
		}
		isActive = dictionary["IsActive"] as? Bool
		isApprove = dictionary["IsApprove"] as? Bool
		make = dictionary["Make"] as? String
		manufacturingYear = dictionary["ManufacturingYear"] as? Int
		passengerCapacity = dictionary["PassengerCapacity"] as? Int
		plateNumber = dictionary["PlateNumber"] as? String
		vIN = dictionary["VIN"] as? String
		vehicleCategoryName = dictionary["VehicleCategoryName"] as? String
		vehicleModel = dictionary["VehicleModel"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if companyId != nil{
			dictionary["CompanyId"] = companyId
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if hasVehicleDocUploaded != nil{
			dictionary["HasVehicleDocUploaded"] = hasVehicleDocUploaded
		}
		if id != nil{
			dictionary["Id"] = id
		}
		if images != nil{
			var dictionaryElements = [NSDictionary]()
			for imagesElement in images {
				dictionaryElements.append(imagesElement.toDictionary())
			}
			dictionary["Images"] = dictionaryElements
		}
		if isActive != nil{
			dictionary["IsActive"] = isActive
		}
		if isApprove != nil{
			dictionary["IsApprove"] = isApprove
		}
		if make != nil{
			dictionary["Make"] = make
		}
		if manufacturingYear != nil{
			dictionary["ManufacturingYear"] = manufacturingYear
		}
		if passengerCapacity != nil{
			dictionary["PassengerCapacity"] = passengerCapacity
		}
		if plateNumber != nil{
			dictionary["PlateNumber"] = plateNumber
		}
		if vIN != nil{
			dictionary["VIN"] = vIN
		}
		if vehicleCategoryName != nil{
			dictionary["VehicleCategoryName"] = vehicleCategoryName
		}
		if vehicleModel != nil{
			dictionary["VehicleModel"] = vehicleModel
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         companyId = aDecoder.decodeObject(forKey: "CompanyId") as? String
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         hasVehicleDocUploaded = aDecoder.decodeObject(forKey: "HasVehicleDocUploaded") as? Bool
         id = aDecoder.decodeObject(forKey: "Id") as? Int
         images = aDecoder.decodeObject(forKey: "Images") as? [Image]
         isActive = aDecoder.decodeObject(forKey: "IsActive") as? Bool
         isApprove = aDecoder.decodeObject(forKey: "IsApprove") as? Bool
         make = aDecoder.decodeObject(forKey: "Make") as? String
         manufacturingYear = aDecoder.decodeObject(forKey: "ManufacturingYear") as? Int
         passengerCapacity = aDecoder.decodeObject(forKey: "PassengerCapacity") as? Int
         plateNumber = aDecoder.decodeObject(forKey: "PlateNumber") as? String
         vIN = aDecoder.decodeObject(forKey: "VIN") as? String
         vehicleCategoryName = aDecoder.decodeObject(forKey: "VehicleCategoryName") as? String
         vehicleModel = aDecoder.decodeObject(forKey: "VehicleModel") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if companyId != nil{
			aCoder.encode(companyId, forKey: "CompanyId")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if hasVehicleDocUploaded != nil{
			aCoder.encode(hasVehicleDocUploaded, forKey: "HasVehicleDocUploaded")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
		}
		if images != nil{
			aCoder.encode(images, forKey: "Images")
		}
		if isActive != nil{
			aCoder.encode(isActive, forKey: "IsActive")
		}
		if isApprove != nil{
			aCoder.encode(isApprove, forKey: "IsApprove")
		}
		if make != nil{
			aCoder.encode(make, forKey: "Make")
		}
		if manufacturingYear != nil{
			aCoder.encode(manufacturingYear, forKey: "ManufacturingYear")
		}
		if passengerCapacity != nil{
			aCoder.encode(passengerCapacity, forKey: "PassengerCapacity")
		}
		if plateNumber != nil{
			aCoder.encode(plateNumber, forKey: "PlateNumber")
		}
		if vIN != nil{
			aCoder.encode(vIN, forKey: "VIN")
		}
		if vehicleCategoryName != nil{
			aCoder.encode(vehicleCategoryName, forKey: "VehicleCategoryName")
		}
		if vehicleModel != nil{
			aCoder.encode(vehicleModel, forKey: "VehicleModel")
		}

	}

}
