//
//	CancelReasonModel.swift
//
//	Create by admin on 13/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CancelReasonModel : NSObject, NSCoding{

	var reason : String!
	var reasonId : Int!
	var reasonType : String!


    
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		reason = dictionary["Reason"] as? String
		reasonId = dictionary["ReasonId"] as? Int
		reasonType = dictionary["ReasonType"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if reason != nil{
			dictionary["Reason"] = reason
		}
		if reasonId != nil{
			dictionary["ReasonId"] = reasonId
		}
		if reasonType != nil{
			dictionary["ReasonType"] = reasonType
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         reason = aDecoder.decodeObject(forKey: "Reason") as? String
         reasonId = aDecoder.decodeObject(forKey: "ReasonId") as? Int
         reasonType = aDecoder.decodeObject(forKey: "ReasonType") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if reason != nil{
			aCoder.encode(reason, forKey: "Reason")
		}
		if reasonId != nil{
			aCoder.encode(reasonId, forKey: "ReasonId")
		}
		if reasonType != nil{
			aCoder.encode(reasonType, forKey: "ReasonType")
		}

	}

}
