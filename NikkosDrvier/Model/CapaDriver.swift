//
//	CapaDriver.swift
//
//	Create by admin on 11/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CapaDriver : NSObject, NSCoding{

	var driverId : Int!
	var firstName : String!
	var lastName : AnyObject!
	var phoneNumber : String!
	var profileImage : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		driverId = dictionary["DriverId"] as? Int
		firstName = dictionary["FirstName"] as? String
		lastName = dictionary["LastName"] as? String as AnyObject
		phoneNumber = dictionary["PhoneNumber"] as? String
		profileImage = dictionary["ProfileImage"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if driverId != nil{
			dictionary["DriverId"] = driverId
		}
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		if lastName != nil{
			dictionary["LastName"] = lastName
		}
		if phoneNumber != nil{
			dictionary["PhoneNumber"] = phoneNumber
		}
		if profileImage != nil{
			dictionary["ProfileImage"] = profileImage
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         firstName = aDecoder.decodeObject(forKey: "FirstName") as? String
         lastName = aDecoder.decodeObject(forKey: "LastName") as? String as AnyObject
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String
         profileImage = aDecoder.decodeObject(forKey: "ProfileImage") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "FirstName")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "LastName")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}
		if profileImage != nil{
			aCoder.encode(profileImage, forKey: "ProfileImage")
		}

	}

}
