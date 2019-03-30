//
//	TripInfoModel.swift
//
//	Create by admin on 29/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TripInfoModel : NSObject, NSCoding{

	var clientId : Int!
	var clientImage : String!
	var clientName : String!
	var clientPhoneNumber : String!
	var clientRating : Double!
	var driverId : Int!
	var driverImage : String!
	var driverLatitude : Double!
	var driverLongitude : Double!
	var driverName : String!
	var driverPhoneNumber : String!
	var driverRating : Double!
	var driverReachedTime : AnyObject!
	var dropLatitude : Double!
	var dropLongitude : Double!
	var hasClientRating : Bool!
	var hasDriverRating : Bool!
	var isTripEnd : Bool!
	var isTripStart : Bool!
	var licenseNumber : String!
	var pickupLatitude : Double!
	var pickupLongitude : Double!
	var platNumber : String!
	var tripId : Int!
	var tripRequestTime : String!
	var tripType : AnyObject!
	var vehicleName : String!
	var vehicleType : String!
	var vtcNumber : String!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		clientId = dictionary["ClientId"] as? Int
		clientImage = dictionary["ClientImage"] as? String
		clientName = dictionary["ClientName"] as? String
		clientPhoneNumber = dictionary["ClientPhoneNumber"] as? String
		clientRating = dictionary["ClientRating"] as? Double
		driverId = dictionary["DriverId"] as? Int
		driverImage = dictionary["DriverImage"] as? String
		driverLatitude = dictionary["DriverLatitude"] as? Double
		driverLongitude = dictionary["DriverLongitude"] as? Double
		driverName = dictionary["DriverName"] as? String
		driverPhoneNumber = dictionary["DriverPhoneNumber"] as? String
		driverRating = dictionary["DriverRating"] as? Double
		driverReachedTime = dictionary["DriverReachedTime"] as? String as AnyObject
		dropLatitude = dictionary["DropLatitude"] as? Double
		dropLongitude = dictionary["DropLongitude"] as? Double
		hasClientRating = dictionary["HasClientRating"] as? Bool
		hasDriverRating = dictionary["HasDriverRating"] as? Bool
		isTripEnd = dictionary["IsTripEnd"] as? Bool
		isTripStart = dictionary["IsTripStart"] as? Bool
		licenseNumber = dictionary["LicenseNumber"] as? String
		pickupLatitude = dictionary["PickupLatitude"] as? Double
		pickupLongitude = dictionary["PickupLongitude"] as? Double
		platNumber = dictionary["PlatNumber"] as? String
		tripId = dictionary["TripId"] as? Int
		tripRequestTime = dictionary["TripRequestTime"] as? String
		tripType = dictionary["TripType"] as? String as AnyObject
		vehicleName = dictionary["VehicleName"] as? String
		vehicleType = dictionary["VehicleType"] as? String
		vtcNumber = dictionary["VtcNumber"] as? String
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if clientId != nil{
			dictionary["ClientId"] = clientId
		}
		if clientImage != nil{
			dictionary["ClientImage"] = clientImage
		}
		if clientName != nil{
			dictionary["ClientName"] = clientName
		}
		if clientPhoneNumber != nil{
			dictionary["ClientPhoneNumber"] = clientPhoneNumber
		}
		if clientRating != nil{
			dictionary["ClientRating"] = clientRating
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if driverImage != nil{
			dictionary["DriverImage"] = driverImage
		}
		if driverLatitude != nil{
			dictionary["DriverLatitude"] = driverLatitude
		}
		if driverLongitude != nil{
			dictionary["DriverLongitude"] = driverLongitude
		}
		if driverName != nil{
			dictionary["DriverName"] = driverName
		}
		if driverPhoneNumber != nil{
			dictionary["DriverPhoneNumber"] = driverPhoneNumber
		}
		if driverRating != nil{
			dictionary["DriverRating"] = driverRating
		}
		if driverReachedTime != nil{
			dictionary["DriverReachedTime"] = driverReachedTime
		}
		if dropLatitude != nil{
			dictionary["DropLatitude"] = dropLatitude
		}
		if dropLongitude != nil{
			dictionary["DropLongitude"] = dropLongitude
		}
		if hasClientRating != nil{
			dictionary["HasClientRating"] = hasClientRating
		}
		if hasDriverRating != nil{
			dictionary["HasDriverRating"] = hasDriverRating
		}
		if isTripEnd != nil{
			dictionary["IsTripEnd"] = isTripEnd
		}
		if isTripStart != nil{
			dictionary["IsTripStart"] = isTripStart
		}
		if licenseNumber != nil{
			dictionary["LicenseNumber"] = licenseNumber
		}
		if pickupLatitude != nil{
			dictionary["PickupLatitude"] = pickupLatitude
		}
		if pickupLongitude != nil{
			dictionary["PickupLongitude"] = pickupLongitude
		}
		if platNumber != nil{
			dictionary["PlatNumber"] = platNumber
		}
		if tripId != nil{
			dictionary["TripId"] = tripId
		}
		if tripRequestTime != nil{
			dictionary["TripRequestTime"] = tripRequestTime
		}
		if tripType != nil{
			dictionary["TripType"] = tripType
		}
		if vehicleName != nil{
			dictionary["VehicleName"] = vehicleName
		}
		if vehicleType != nil{
			dictionary["VehicleType"] = vehicleType
		}
		if vtcNumber != nil{
			dictionary["VtcNumber"] = vtcNumber
		}
		if success != nil{
			dictionary["success"] = success
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         clientId = aDecoder.decodeObject(forKey: "ClientId") as? Int
         clientImage = aDecoder.decodeObject(forKey: "ClientImage") as? String
         clientName = aDecoder.decodeObject(forKey: "ClientName") as? String
         clientPhoneNumber = aDecoder.decodeObject(forKey: "ClientPhoneNumber") as? String
         clientRating = aDecoder.decodeObject(forKey: "ClientRating") as? Double
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         driverImage = aDecoder.decodeObject(forKey: "DriverImage") as? String
         driverLatitude = aDecoder.decodeObject(forKey: "DriverLatitude") as? Double
         driverLongitude = aDecoder.decodeObject(forKey: "DriverLongitude") as? Double
         driverName = aDecoder.decodeObject(forKey: "DriverName") as? String
         driverPhoneNumber = aDecoder.decodeObject(forKey: "DriverPhoneNumber") as? String
         driverRating = aDecoder.decodeObject(forKey: "DriverRating") as? Double
         driverReachedTime = aDecoder.decodeObject(forKey: "DriverReachedTime") as? String as AnyObject
         dropLatitude = aDecoder.decodeObject(forKey: "DropLatitude") as? Double
         dropLongitude = aDecoder.decodeObject(forKey: "DropLongitude") as? Double
         hasClientRating = aDecoder.decodeObject(forKey: "HasClientRating") as? Bool
         hasDriverRating = aDecoder.decodeObject(forKey: "HasDriverRating") as? Bool
         isTripEnd = aDecoder.decodeObject(forKey: "IsTripEnd") as? Bool
         isTripStart = aDecoder.decodeObject(forKey: "IsTripStart") as? Bool
         licenseNumber = aDecoder.decodeObject(forKey: "LicenseNumber") as? String
         pickupLatitude = aDecoder.decodeObject(forKey: "PickupLatitude") as? Double
         pickupLongitude = aDecoder.decodeObject(forKey: "PickupLongitude") as? Double
         platNumber = aDecoder.decodeObject(forKey: "PlatNumber") as? String
         tripId = aDecoder.decodeObject(forKey: "TripId") as? Int
         tripRequestTime = aDecoder.decodeObject(forKey: "TripRequestTime") as? String
         tripType = aDecoder.decodeObject(forKey: "TripType") as? String as AnyObject
         vehicleName = aDecoder.decodeObject(forKey: "VehicleName") as? String
         vehicleType = aDecoder.decodeObject(forKey: "VehicleType") as? String
         vtcNumber = aDecoder.decodeObject(forKey: "VtcNumber") as? String
         success = aDecoder.decodeObject(forKey: "success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if clientId != nil{
			aCoder.encode(clientId, forKey: "ClientId")
		}
		if clientImage != nil{
			aCoder.encode(clientImage, forKey: "ClientImage")
		}
		if clientName != nil{
			aCoder.encode(clientName, forKey: "ClientName")
		}
		if clientPhoneNumber != nil{
			aCoder.encode(clientPhoneNumber, forKey: "ClientPhoneNumber")
		}
		if clientRating != nil{
			aCoder.encode(clientRating, forKey: "ClientRating")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if driverImage != nil{
			aCoder.encode(driverImage, forKey: "DriverImage")
		}
		if driverLatitude != nil{
			aCoder.encode(driverLatitude, forKey: "DriverLatitude")
		}
		if driverLongitude != nil{
			aCoder.encode(driverLongitude, forKey: "DriverLongitude")
		}
		if driverName != nil{
			aCoder.encode(driverName, forKey: "DriverName")
		}
		if driverPhoneNumber != nil{
			aCoder.encode(driverPhoneNumber, forKey: "DriverPhoneNumber")
		}
		if driverRating != nil{
			aCoder.encode(driverRating, forKey: "DriverRating")
		}
		if driverReachedTime != nil{
			aCoder.encode(driverReachedTime, forKey: "DriverReachedTime")
		}
		if dropLatitude != nil{
			aCoder.encode(dropLatitude, forKey: "DropLatitude")
		}
		if dropLongitude != nil{
			aCoder.encode(dropLongitude, forKey: "DropLongitude")
		}
		if hasClientRating != nil{
			aCoder.encode(hasClientRating, forKey: "HasClientRating")
		}
		if hasDriverRating != nil{
			aCoder.encode(hasDriverRating, forKey: "HasDriverRating")
		}
		if isTripEnd != nil{
			aCoder.encode(isTripEnd, forKey: "IsTripEnd")
		}
		if isTripStart != nil{
			aCoder.encode(isTripStart, forKey: "IsTripStart")
		}
		if licenseNumber != nil{
			aCoder.encode(licenseNumber, forKey: "LicenseNumber")
		}
		if pickupLatitude != nil{
			aCoder.encode(pickupLatitude, forKey: "PickupLatitude")
		}
		if pickupLongitude != nil{
			aCoder.encode(pickupLongitude, forKey: "PickupLongitude")
		}
		if platNumber != nil{
			aCoder.encode(platNumber, forKey: "PlatNumber")
		}
		if tripId != nil{
			aCoder.encode(tripId, forKey: "TripId")
		}
		if tripRequestTime != nil{
			aCoder.encode(tripRequestTime, forKey: "TripRequestTime")
		}
		if tripType != nil{
			aCoder.encode(tripType, forKey: "TripType")
		}
		if vehicleName != nil{
			aCoder.encode(vehicleName, forKey: "VehicleName")
		}
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "VehicleType")
		}
		if vtcNumber != nil{
			aCoder.encode(vtcNumber, forKey: "VtcNumber")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}
