//
//	FaqModal.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class FaqModal : NSObject, NSCoding{

	var answer : String!
	var faqId : Int!
	var question : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		answer = dictionary["Answer"] as? String
		faqId = dictionary["FaqId"] as? Int
		question = dictionary["Question"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if answer != nil{
			dictionary["Answer"] = answer
		}
		if faqId != nil{
			dictionary["FaqId"] = faqId
		}
		if question != nil{
			dictionary["Question"] = question
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         answer = aDecoder.decodeObject(forKey: "Answer") as? String
         faqId = aDecoder.decodeObject(forKey: "FaqId") as? Int
         question = aDecoder.decodeObject(forKey: "Question") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if answer != nil{
			aCoder.encode(answer, forKey: "Answer")
		}
		if faqId != nil{
			aCoder.encode(faqId, forKey: "FaqId")
		}
		if question != nil{
			aCoder.encode(question, forKey: "Question")
		}

	}

}
