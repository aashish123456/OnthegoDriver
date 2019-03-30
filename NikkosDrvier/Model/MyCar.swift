//
//	MyCar.swift
//
//	Create by admin on 12/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class MyCar : NSObject, NSCoding{

	var message : String!
	var newRecordId : Int!
	var success : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		message = dictionary["Message"] as? String
		newRecordId = dictionary["NewRecordId"] as? Int
		success = dictionary["success"] as? Bool
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if message != nil{
			dictionary["Message"] = message
		}
		if newRecordId != nil{
			dictionary["NewRecordId"] = newRecordId
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
         message = aDecoder.decodeObject(forKey: "Message") as? String
         newRecordId = aDecoder.decodeObject(forKey: "NewRecordId") as? Int
         success = aDecoder.decodeObject(forKey: "success") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if message != nil{
			aCoder.encode(message, forKey: "Message")
		}
		if newRecordId != nil{
			aCoder.encode(newRecordId, forKey: "NewRecordId")
		}
		if success != nil{
			aCoder.encode(success, forKey: "success")
		}

	}

}
