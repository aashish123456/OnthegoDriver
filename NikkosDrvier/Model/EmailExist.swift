//
//	EmailExist.swift
//
//	Create by admin on 29/12/2016
//	Copyright © 2016. All rights reserved.
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class EmailExist : NSObject, NSCoding{

	var companyAddress : String!
	var companyName : String!
	var companyVatTaxNumber : String!
	var companyZipCode : String!
	var countryId : Int!
	var driverId : Int!
	var driverLicenseNumber : String!
	var driverRating : String!
	var driverType : String!
	var drivingRange : Int!
	var email : String!
	var evtcCapaTaxiNumber : String!
	var firstName : String!
	var hasDriverDocAdded : Bool!
	var hasVehicleAdded : Bool!
	var hasVehicleDocAdded : Bool!
	var isCapa : Bool!
	var isDriverActive : Bool!
	var isEmailVerified : Bool!
	var isOnline : Bool!
	var isPhoneVerified : Bool!
	var isUserActive : Bool!
	var lastName : String!
	var phoneNumber : String!
	var profileImage : String!
	var registrationNumber : String!
	var salutation : String!
	var siretRregistrationCode : String!
	var societyType : String!
	var userId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		companyAddress = dictionary["CompanyAddress"] as? String
		companyName = dictionary["CompanyName"] as? String
		companyVatTaxNumber = dictionary["CompanyVat_TaxNumber"] as? String
		companyZipCode = dictionary["CompanyZipCode"] as? String
		countryId = dictionary["CountryId"] as? Int
		driverId = dictionary["DriverId"] as? Int
		driverLicenseNumber = dictionary["DriverLicenseNumber"] as? String
		driverRating = dictionary["DriverRating"] as? String
		driverType = dictionary["DriverType"] as? String
		drivingRange = dictionary["DrivingRange"] as? Int
		email = dictionary["Email"] as? String
		evtcCapaTaxiNumber = dictionary["Evtc_Capa_Taxi_Number"] as? String
		firstName = dictionary["FirstName"] as? String
		hasDriverDocAdded = dictionary["HasDriverDocAdded"] as? Bool
		hasVehicleAdded = dictionary["HasVehicleAdded"] as? Bool
		hasVehicleDocAdded = dictionary["HasVehicleDocAdded"] as? Bool
		isCapa = dictionary["IsCapa"] as? Bool
		isDriverActive = dictionary["IsDriverActive"] as? Bool
		isEmailVerified = dictionary["IsEmailVerified"] as? Bool
		isOnline = dictionary["IsOnline"] as? Bool
		isPhoneVerified = dictionary["IsPhoneVerified"] as? Bool
		isUserActive = dictionary["IsUserActive"] as? Bool
		lastName = dictionary["LastName"] as? String
		phoneNumber = dictionary["PhoneNumber"] as? String
		profileImage = dictionary["ProfileImage"] as? String
		registrationNumber = dictionary["RegistrationNumber"] as? String
		salutation = dictionary["Salutation"] as? String
		siretRregistrationCode = dictionary["Siret_RregistrationCode"] as? String
		societyType = dictionary["SocietyType"] as? String
		userId = dictionary["UserId"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if companyAddress != nil{
			dictionary["CompanyAddress"] = companyAddress
		}
		if companyName != nil{
			dictionary["CompanyName"] = companyName
		}
		if companyVatTaxNumber != nil{
			dictionary["CompanyVat_TaxNumber"] = companyVatTaxNumber
		}
		if companyZipCode != nil{
			dictionary["CompanyZipCode"] = companyZipCode
		}
		if countryId != nil{
			dictionary["CountryId"] = countryId
		}
		if driverId != nil{
			dictionary["DriverId"] = driverId
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
		if drivingRange != nil{
			dictionary["DrivingRange"] = drivingRange
		}
		if email != nil{
			dictionary["Email"] = email
		}
		if evtcCapaTaxiNumber != nil{
			dictionary["Evtc_Capa_Taxi_Number"] = evtcCapaTaxiNumber
		}
		if firstName != nil{
			dictionary["FirstName"] = firstName
		}
		if hasDriverDocAdded != nil{
			dictionary["HasDriverDocAdded"] = hasDriverDocAdded
		}
		if hasVehicleAdded != nil{
			dictionary["HasVehicleAdded"] = hasVehicleAdded
		}
		if hasVehicleDocAdded != nil{
			dictionary["HasVehicleDocAdded"] = hasVehicleDocAdded
		}
		if isCapa != nil{
			dictionary["IsCapa"] = isCapa
		}
		if isDriverActive != nil{
			dictionary["IsDriverActive"] = isDriverActive
		}
		if isEmailVerified != nil{
			dictionary["IsEmailVerified"] = isEmailVerified
		}
		if isOnline != nil{
			dictionary["IsOnline"] = isOnline
		}
		if isPhoneVerified != nil{
			dictionary["IsPhoneVerified"] = isPhoneVerified
		}
		if isUserActive != nil{
			dictionary["IsUserActive"] = isUserActive
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
		if registrationNumber != nil{
			dictionary["RegistrationNumber"] = registrationNumber
		}
		if salutation != nil{
			dictionary["Salutation"] = salutation
		}
		if siretRregistrationCode != nil{
			dictionary["Siret_RregistrationCode"] = siretRregistrationCode
		}
		if societyType != nil{
			dictionary["SocietyType"] = societyType
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
         companyAddress = aDecoder.decodeObject(forKey: "CompanyAddress") as? String
         companyName = aDecoder.decodeObject(forKey: "CompanyName") as? String
         companyVatTaxNumber = aDecoder.decodeObject(forKey: "CompanyVat_TaxNumber") as? String
         companyZipCode = aDecoder.decodeObject(forKey: "CompanyZipCode") as? String
         countryId = aDecoder.decodeObject(forKey: "CountryId") as? Int
         driverId = aDecoder.decodeObject(forKey: "DriverId") as? Int
         driverLicenseNumber = aDecoder.decodeObject(forKey: "DriverLicenseNumber") as? String
         driverRating = aDecoder.decodeObject(forKey: "DriverRating") as? String
         driverType = aDecoder.decodeObject(forKey: "DriverType") as? String
         drivingRange = aDecoder.decodeObject(forKey: "DrivingRange") as? Int
         email = aDecoder.decodeObject(forKey: "Email") as? String
         evtcCapaTaxiNumber = aDecoder.decodeObject(forKey: "Evtc_Capa_Taxi_Number") as? String
         firstName = aDecoder.decodeObject(forKey: "FirstName") as? String
         hasDriverDocAdded = aDecoder.decodeObject(forKey: "HasDriverDocAdded") as? Bool
         hasVehicleAdded = aDecoder.decodeObject(forKey: "HasVehicleAdded") as? Bool
         hasVehicleDocAdded = aDecoder.decodeObject(forKey: "HasVehicleDocAdded") as? Bool
         isCapa = aDecoder.decodeObject(forKey: "IsCapa") as? Bool
         isDriverActive = aDecoder.decodeObject(forKey: "IsDriverActive") as? Bool
         isEmailVerified = aDecoder.decodeObject(forKey: "IsEmailVerified") as? Bool
         isOnline = aDecoder.decodeObject(forKey: "IsOnline") as? Bool
         isPhoneVerified = aDecoder.decodeObject(forKey: "IsPhoneVerified") as? Bool
         isUserActive = aDecoder.decodeObject(forKey: "IsUserActive") as? Bool
         lastName = aDecoder.decodeObject(forKey: "LastName") as? String
         phoneNumber = aDecoder.decodeObject(forKey: "PhoneNumber") as? String
         profileImage = aDecoder.decodeObject(forKey: "ProfileImage") as? String
         registrationNumber = aDecoder.decodeObject(forKey: "RegistrationNumber") as? String
         salutation = aDecoder.decodeObject(forKey: "Salutation") as? String
         siretRregistrationCode = aDecoder.decodeObject(forKey: "Siret_RregistrationCode") as? String
         societyType = aDecoder.decodeObject(forKey: "SocietyType") as? String
         userId = aDecoder.decodeObject(forKey: "UserId") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if companyAddress != nil{
			aCoder.encode(companyAddress, forKey: "CompanyAddress")
		}
		if companyName != nil{
			aCoder.encode(companyName, forKey: "CompanyName")
		}
		if companyVatTaxNumber != nil{
			aCoder.encode(companyVatTaxNumber, forKey: "CompanyVat_TaxNumber")
		}
		if companyZipCode != nil{
			aCoder.encode(companyZipCode, forKey: "CompanyZipCode")
		}
		if countryId != nil{
			aCoder.encode(countryId, forKey: "CountryId")
		}
		if driverId != nil{
			aCoder.encode(driverId, forKey: "DriverId")
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
		if drivingRange != nil{
			aCoder.encode(drivingRange, forKey: "DrivingRange")
		}
		if email != nil{
			aCoder.encode(email, forKey: "Email")
		}
		if evtcCapaTaxiNumber != nil{
			aCoder.encode(evtcCapaTaxiNumber, forKey: "Evtc_Capa_Taxi_Number")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "FirstName")
		}
		if hasDriverDocAdded != nil{
			aCoder.encode(hasDriverDocAdded, forKey: "HasDriverDocAdded")
		}
		if hasVehicleAdded != nil{
			aCoder.encode(hasVehicleAdded, forKey: "HasVehicleAdded")
		}
		if hasVehicleDocAdded != nil{
			aCoder.encode(hasVehicleDocAdded, forKey: "HasVehicleDocAdded")
		}
		if isCapa != nil{
			aCoder.encode(isCapa, forKey: "IsCapa")
		}
		if isDriverActive != nil{
			aCoder.encode(isDriverActive, forKey: "IsDriverActive")
		}
		if isEmailVerified != nil{
			aCoder.encode(isEmailVerified, forKey: "IsEmailVerified")
		}
		if isOnline != nil{
			aCoder.encode(isOnline, forKey: "IsOnline")
		}
		if isPhoneVerified != nil{
			aCoder.encode(isPhoneVerified, forKey: "IsPhoneVerified")
		}
		if isUserActive != nil{
			aCoder.encode(isUserActive, forKey: "IsUserActive")
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
		if registrationNumber != nil{
			aCoder.encode(registrationNumber, forKey: "RegistrationNumber")
		}
		if salutation != nil{
			aCoder.encode(salutation, forKey: "Salutation")
		}
		if siretRregistrationCode != nil{
			aCoder.encode(siretRregistrationCode, forKey: "Siret_RregistrationCode")
		}
		if societyType != nil{
			aCoder.encode(societyType, forKey: "SocietyType")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "UserId")
		}

	}

}
