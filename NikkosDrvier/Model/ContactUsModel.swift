//
//	ContactUsModel.swift
//
//	Create by admin on 22/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ContactUsModel : NSObject, NSCoding{

	var address : String!
	var email : String!
	var phoneNumber : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		address = dictionary["Address"] as? String
		email = dictionary["Email"] as? String
		phoneNumber = dictionary["PhoneNumber"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if address != nil{
			dictionary["Address"] = address
		}
		if email != nil{
			dictionary["Email"] = email
		}
		if phoneNumber != nil{
			dictionary["PhoneNumber"] = phoneNumber
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         address = aDecoder.decodeObject(forKey: "Address") as? String
         email = aDecoder.decodeObject(forKey: "Email") as? String
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if address != nil{
			aCoder.encode(address, forKey: "Address")
		}
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if phoneNumber != nil{
			aCoder.encode(phoneNumber, forKey: "PhoneNumber")
		}

	}

}
