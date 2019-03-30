//
//	liveGPS.swift
//
//	Create by admin on 15/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class liveGPS : NSObject, NSCoding{

	var course : String!
	var driverId : Int!
	var locationLat : Double!
	var locationLong : Double!
	var vehicleType : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		course = dictionary["Course"] as? String
		driverId = dictionary["DriverId"] as? Int
		locationLat = dictionary["LocationLat"] as? Double
		locationLong = dictionary["LocationLong"] as? Double
		vehicleType = dictionary["VehicleType"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if course != nil{
			dictionary["Course"] = course
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if locationLat != nil{
			dictionary["LocationLat"] = locationLat
		}
		if locationLong != nil{
			dictionary["LocationLong"] = locationLong
		}
		if vehicleType != nil{
			dictionary["VehicleType"] = vehicleType
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         course = aDecoder.decodeObject(forKey: "Course") as? String
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         locationLat = aDecoder.decodeObject(forKey: "LocationLat") as? Double
         locationLong = aDecoder.decodeObject(forKey: "LocationLong") as? Double
         vehicleType = aDecoder.decodeObject(forKey: "VehicleType") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if course != nil{
			aCoder.encode(course, forKey: "Course")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if locationLat != nil{
			aCoder.encode(locationLat, forKey: "LocationLat")
		}
		if locationLong != nil{
			aCoder.encode(locationLong, forKey: "LocationLong")
		}
		if vehicleType != nil{
			aCoder.encode(vehicleType, forKey: "VehicleType")
		}

	}

}
