//
//	BalanceSheetListModel.swift
//
//	Create by admin on 18/11/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class BalanceSheetListModel : NSObject, NSCoding{

	var endDate : String!
	var list : [BalanceSheetModel]!
	var startDate : String!
	var total : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		endDate = dictionary["EndDate"] as? String
		list = [BalanceSheetModel]()
		if let listArray = dictionary["List"] as? [NSDictionary]{
			for dic in listArray{
				let value = BalanceSheetModel(fromDictionary: dic)
				list.append(value)
			}
		}
		startDate = dictionary["StartDate"] as? String
		total = dictionary["Total"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if endDate != nil{
			dictionary["EndDate"] = endDate
		}
		if list != nil{
			var dictionaryElements = [NSDictionary]()
			for listElement in list {
				dictionaryElements.append(listElement.toDictionary())
			}
			dictionary["List"] = dictionaryElements
		}
		if startDate != nil{
			dictionary["StartDate"] = startDate
		}
		if total != nil{
			dictionary["Total"] = total
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         endDate = aDecoder.decodeObject(forKey: "EndDate") as? String
         list = aDecoder.decodeObject(forKey: "List") as? [BalanceSheetModel]
         startDate = aDecoder.decodeObject(forKey: "StartDate") as? String
         total = aDecoder.decodeObject(forKey: "Total") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if endDate != nil{
			aCoder.encode(endDate, forKey: "EndDate")
		}
		if list != nil{
			aCoder.encode(list, forKey: "List")
		}
		if startDate != nil{
			aCoder.encode(startDate, forKey: "StartDate")
		}
		if total != nil{
			aCoder.encode(total, forKey: "Total")
		}

	}

}
