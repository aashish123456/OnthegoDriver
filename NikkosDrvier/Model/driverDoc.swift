//
//	driverDoc.swift
//
//	Create by admin on 10/10/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import CoreData

class driverDoc : NSManagedObject{

	@NSManaged var text : String!
	@NSManaged var text2 : String!
	@NSManaged var value : Int


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary, context: NSManagedObjectContext)	{
		let entity = NSEntityDescription.entity(forEntityName: "driverDoc", in: context)!
		super.init(entity: entity, insertInto: context)
		if let textValue = dictionary["Text"] as? String{
			text = textValue
		}
		if let text2Value = dictionary["Text2"] as? String{
			text2 = text2Value
		}
		if let valueValue = dictionary["Value"] as? Int{
			value = valueValue
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if text != nil{
			dictionary["Text"] = text
		}
		if text2 != nil{
			dictionary["Text2"] = text2
		}
		dictionary["Value"] = value
		return dictionary
	}

}
