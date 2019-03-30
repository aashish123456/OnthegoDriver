//
//	UserModel.swift
//
//	Create by admin on 9/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserModel : NSObject, NSCoding{

	var driverId : Int!
	var email : String!
	var firstName : String!
	var lastName : String!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		driverId = dictionary["DriverId"] as? Int
		email = dictionary["Email"] as? String
		firstName = dictionary["FirstName"] as? String
		lastName = dictionary["LastName"] as? String
		userId = dictionary["UserId"] as? Int
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
		if email != nil{
			dictionary["Email"] = email
		}
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		if lastName != nil{
			dictionary["LastName"] = lastName
		}
		if userId != nil{
			dictionary["UserId"] = userId
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
         email = aDecoder.decodeObject(forKey: "Email") as? String
         firstName = aDecoder.decodeObject(forKey: "FirstName") as? String
         lastName = aDecoder.decodeObject(forKey: "LastName") as? String
         userId = aDecoder.decodeObject(forKey: "UserId") as? Int

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
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "FirstName")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "LastName")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "UserId")
		}

	}

}
