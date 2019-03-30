//
//	BalanceSheetModel.swift
//
//	Create by admin on 7/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BalanceSheetModel : NSObject, NSCoding{

	var amount : String!
	var clientName : String!
	var driverId : Int!
	var driverName : String!
	var hasPaidToDriver : Bool!
	var particulars : String!
	var tripDate : String!
	var tripId : Int!
	var tripRequestId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		amount = dictionary["Amount"] as? String
		clientName = dictionary["ClientName"] as? String
		driverId = dictionary["DriverId"] as? Int
		driverName = dictionary["DriverName"] as? String
		hasPaidToDriver = dictionary["HasPaidToDriver"] as? Bool
		particulars = dictionary["Particulars"] as? String
		tripDate = dictionary["TripDate"] as? String
		tripId = dictionary["TripId"] as? Int
		tripRequestId = dictionary["TripRequestId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if amount != nil{
			dictionary["Amount"] = amount
		}
		if clientName != nil{
			dictionary["ClientName"] = clientName
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if driverName != nil{
			dictionary["DriverName"] = driverName
		}
		if hasPaidToDriver != nil{
			dictionary["HasPaidToDriver"] = hasPaidToDriver
		}
		if particulars != nil{
			dictionary["Particulars"] = particulars
		}
		if tripDate != nil{
			dictionary["TripDate"] = tripDate
		}
		if tripId != nil{
			dictionary["TripId"] = tripId
		}
		if tripRequestId != nil{
			dictionary["TripRequestId"] = tripRequestId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         amount = aDecoder.decodeObject(forKey: "Amount") as? String
         clientName = aDecoder.decodeObject(forKey: "ClientName") as? String
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         driverName = aDecoder.decodeObject(forKey: "DriverName") as? String
         hasPaidToDriver = aDecoder.decodeObject(forKey: "HasPaidToDriver") as? Bool
         particulars = aDecoder.decodeObject(forKey: "Particulars") as? String
         tripDate = aDecoder.decodeObject(forKey: "TripDate") as? String
         tripId = aDecoder.decodeObject(forKey: "TripId") as? Int
         tripRequestId = aDecoder.decodeObject(forKey: "TripRequestId") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if amount != nil{
			aCoder.encode(amount, forKey: "Amount")
		}
		if clientName != nil{
			aCoder.encode(clientName, forKey: "ClientName")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if driverName != nil{
			aCoder.encode(driverName, forKey: "DriverName")
		}
		if hasPaidToDriver != nil{
			aCoder.encode(hasPaidToDriver, forKey: "HasPaidToDriver")
		}
		if particulars != nil{
			aCoder.encode(particulars, forKey: "Particulars")
		}
		if tripDate != nil{
			aCoder.encode(tripDate, forKey: "TripDate")
		}
		if tripId != nil{
			aCoder.encode(tripId, forKey: "TripId")
		}
		if tripRequestId != nil{
			aCoder.encode(tripRequestId, forKey: "TripRequestId")
		}

	}

}
