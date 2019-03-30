//
//	List.swift
//
//	Create by admin on 18/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class List : NSObject, NSCoding{

	var amount : String!
	var clientName : String!
	var driverId : Int!
	var particulars : String!
	var tripDate : String!
	var tripId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		amount = dictionary["Amount"] as? String
		clientName = dictionary["ClientName"] as? String
		driverId = dictionary["DriverId"] as? Int
		particulars = dictionary["Particulars"] as? String
		tripDate = dictionary["TripDate"] as? String
		tripId = dictionary["TripId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		var dictionary = NSMutableDictionary()
		if amount != nil{
			dictionary["Amount"] = amount
		}
		if clientName != nil{
			dictionary["ClientName"] = clientName
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
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
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         amount = aDecoder.decodeObjectForKey("Amount") as? String
         clientName = aDecoder.decodeObjectForKey("ClientName") as? String
         driverId = aDecoder.decodeObjectForKey("DriverId") as? Int
         particulars = aDecoder.decodeObjectForKey("Particulars") as? String
         tripDate = aDecoder.decodeObjectForKey("TripDate") as? String
         tripId = aDecoder.decodeObjectForKey("TripId") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if amount != nil{
			aCoder.encodeObject(amount, forKey: "Amount")
		}
		if clientName != nil{
			aCoder.encodeObject(clientName, forKey: "ClientName")
		}
		if driverId != nil{
			aCoder.encodeObject(driverId, forKey: "DriverId")
		}
		if particulars != nil{
			aCoder.encodeObject(particulars, forKey: "Particulars")
		}
		if tripDate != nil{
			aCoder.encodeObject(tripDate, forKey: "TripDate")
		}
		if tripId != nil{
			aCoder.encodeObject(tripId, forKey: "TripId")
		}

	}

}