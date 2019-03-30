//
//	ProfileModel.swift
//
//	Create by admin on 7/9/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class ProfileModel : NSObject, NSCoding{

	var companyName : String!
	var driverLicenseNumber : String!
	var driverRating : String!
	var driverType : String!
	var email : String!
	var firstName : String!
	var id : Int!
	var lastName : String!
	var phoneNumber : String!
	var profileImage : String!
	var salutation : String!
	var societyType : String!
	var vTCNumber : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		companyName = dictionary["CompanyName"] as? String
		driverLicenseNumber = dictionary["DriverLicenseNumber"] as? String
		driverRating = dictionary["DriverRating"] as? String
		driverType = dictionary["DriverType"] as? String
		email = dictionary["Email"] as? String
		firstName = dictionary["FirstName"] as? String
		id = dictionary["Id"] as? Int
		lastName = dictionary["LastName"] as? String
		phoneNumber = dictionary["PhoneNumber"] as? String
		profileImage = dictionary["ProfileImage"] as? String
		salutation = dictionary["Salutation"] as? String
		societyType = dictionary["SocietyType"] as? String
		vTCNumber = dictionary["VTCNumber"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if companyName != nil{
			dictionary["CompanyName"] = companyName
		}
		if driverLicenseNumber != nil{
			dictionary["DriverLicenseNumber"] = driverLicenseNumber
		}
		if driverRating != nil{
			dictionary["DriverRating"] = driverRating
		}
		if driverType != nil{
			dictionary["DriverType"] = driverType
		}
		if email != nil{
			dictionary["Email"] = email
		}
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		if id != nil{
			dictionary["Id"] = id
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
		if salutation != nil{
			dictionary["Salutation"] = salutation
		}
		if societyType != nil{
			dictionary["SocietyType"] = societyType
		}
		if vTCNumber != nil{
			dictionary["VTCNumber"] = vTCNumber
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         companyName = aDecoder.decodeObject(forKey: "CompanyName") as? String
         driverLicenseNumber = aDecoder.decodeObject(forKey: "DriverLicenseNumber") as? String
         driverRating = aDecoder.decodeObject(forKey: "DriverRating") as? String
         driverType = aDecoder.decodeObject(forKey: "DriverType") as? String
         email = aDecoder.decodeObject(forKey: "Email") as? String
         firstName = aDecoder.decodeObject(forKey: "FirstName") as? String
         id = aDecoder.decodeObject(forKey: "Id") as? Int
         lastName = aDecoder.decodeObject(forKey: "LastName") as? String
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String
         profileImage = aDecoder.decodeObject(forKey: "ProfileImage") as? String
         salutation = aDecoder.decodeObject(forKey: "Salutation") as? String
         societyType = aDecoder.decodeObject(forKey: "SocietyType") as? String
         vTCNumber = aDecoder.decodeObject(forKey: "VTCNumber") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if companyName != nil{
			aCoder.encode(companyName, forKey: "CompanyName")
		}
		if driverLicenseNumber != nil{
			aCoder.encode(driverLicenseNumber, forKey: "DriverLicenseNumber")
		}
		if driverRating != nil{
			aCoder.encode(driverRating, forKey: "DriverRating")
		}
		if driverType != nil{
			aCoder.encode(driverType, forKey: "DriverType")
		}
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "FirstName")
		}
		if id != nil{
			aCoder.encode(id, forKey: "Id")
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
		if salutation != nil{
			aCoder.encode(salutation, forKey: "Salutation")
		}
		if societyType != nil{
			aCoder.encode(societyType, forKey: "SocietyType")
		}
		if vTCNumber != nil{
			aCoder.encode(vTCNumber, forKey: "VTCNumber")
		}

	}

}
