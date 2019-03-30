//
//	CodeModel.swift
//
//	Create by admin on 29/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class CodeModel : NSObject, NSCoding{

	var code : String!
	var countryId : Int!
	var flag : String!
	var name : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		code = dictionary["Code"] as? String
		countryId = dictionary["CountryId"] as? Int
		flag = dictionary["Flag"] as? String
		name = dictionary["Name"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if code != nil{
			dictionary["Code"] = code
		}
		if countryId != nil{
			dictionary["CountryId"] = countryId
		}
		if flag != nil{
			dictionary["Flag"] = flag
		}
		if name != nil{
			dictionary["Name"] = name
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         code = aDecoder.decodeObject(forKey: "Code") as? String
         countryId = aDecoder.decodeObject(forKey: "CountryId") as? Int
         flag = aDecoder.decodeObject(forKey: "Flag") as? String
         name = aDecoder.decodeObject(forKey: "Name") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if code != nil{
			aCoder.encode(code, forKey: "Code")
		}
		if countryId != nil{
			aCoder.encode(countryId, forKey: "CountryId")
		}
		if flag != nil{
			aCoder.encode(flag, forKey: "Flag")
		}
		if name != nil{
			aCoder.encode(name, forKey: "Name")
		}

	}

}
